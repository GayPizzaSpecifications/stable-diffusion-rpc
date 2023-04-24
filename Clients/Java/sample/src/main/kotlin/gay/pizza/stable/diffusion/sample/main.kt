package gay.pizza.stable.diffusion.sample

import com.google.protobuf.ByteString
import gay.pizza.stable.diffusion.StableDiffusion.*
import gay.pizza.stable.diffusion.StableDiffusionRpcClient
import io.grpc.ManagedChannelBuilder
import kotlin.io.path.Path
import kotlin.io.path.exists
import kotlin.io.path.readBytes
import kotlin.io.path.writeBytes
import kotlin.system.exitProcess

fun main(args: Array<String>) {
  val chosenModelName = if (args.isNotEmpty()) args[0] else null
  val chosenPrompt = if (args.size >= 2) args[1] else "cat"
  val chosenNegativePrompt = if (args.size >= 3) args[2] else "bad, nsfw, low quality"

  val channel = ManagedChannelBuilder
    .forAddress("127.0.0.1", 4546)
    .usePlaintext()
    .build()

  val client = StableDiffusionRpcClient(channel)
  val modelListResponse = client.modelServiceBlocking.listModels(ListModelsRequest.getDefaultInstance())
  if (modelListResponse.availableModelsList.isEmpty()) {
    println("no available models")
    exitProcess(0)
  }
  println("available models:")
  for (model in modelListResponse.availableModelsList) {
    val maybeLoadedComputeUnits = if (model.isLoaded) " loaded_compute_units=${model.loadedComputeUnits.name}" else ""
    println("  model ${model.name} attention=${model.attention} loaded=${model.isLoaded}${maybeLoadedComputeUnits}")
  }

  val model = if (chosenModelName == null) {
    modelListResponse.availableModelsList.random()
  } else {
    modelListResponse.availableModelsList.first { it.name == chosenModelName }
  }

  if (!model.isLoaded) {
    println("loading model ${model.name}...")
    client.modelServiceBlocking.loadModel(LoadModelRequest.newBuilder().apply {
      modelName = model.name
      computeUnits = model.supportedComputeUnitsList.first()
    }.build())
  } else {
    println("using model ${model.name}...")
  }

  println("tokenizing prompts...")

  val tokenizePromptResponse = client.tokenizerServiceBlocking.tokenize(TokenizeRequest.newBuilder().apply {
    modelName = model.name
    input = chosenPrompt
  }.build())
  val tokenizeNegativePromptResponse = client.tokenizerServiceBlocking.tokenize(TokenizeRequest.newBuilder().apply {
    modelName = model.name
    input = chosenNegativePrompt
  }.build())

  println("tokenize prompt='${chosenPrompt}' " +
    "tokens=[${tokenizePromptResponse.tokensList.joinToString(", ")}] " +
    "token_ids=[${tokenizePromptResponse.tokenIdsList.joinToString(", ")}]")

  println("tokenize negative_prompt='${chosenNegativePrompt}' " +
    "tokens=[${tokenizeNegativePromptResponse.tokensList.joinToString(", ")}] " +
    "token_ids=[${tokenizeNegativePromptResponse.tokenIdsList.joinToString(", ")}]")

  println("generating images...")

  val startingImagePath = Path("work/start.png")

  val request = GenerateImagesRequest.newBuilder().apply {
    modelName = model.name
    outputImageFormat = ImageFormat.png
    batchSize = 2
    batchCount = 2
    prompt = chosenPrompt
    negativePrompt = chosenNegativePrompt
    if (startingImagePath.exists()) {
      val image = Image.newBuilder().apply {
        format = ImageFormat.png
        data = ByteString.copyFrom(startingImagePath.readBytes())
      }.build()

      startingImage = image
    }
  }.build()
  for ((updateIndex, update) in client.imageGenerationServiceBlocking.generateImagesStreaming(request).withIndex()) {
    if (update.hasBatchProgress()) {
      println("batch=${update.currentBatch} " +
        "progress=${prettyProgressValue(update.batchProgress.percentageComplete)}% " +
        "overall=${prettyProgressValue(update.overallPercentageComplete)}%")
      for ((index, image) in update.batchProgress.imagesList.withIndex()) {
        val imageIndex = ((update.currentBatch - 1) * request.batchSize) + (index + 1)
        println("image=$imageIndex update=$updateIndex format=${image.format.name} data=(${image.data.size()} bytes)")
        val path = Path("work/intermediate_${imageIndex}_${updateIndex}.${image.format.name}")
        path.writeBytes(image.data.toByteArray())
      }
    }

    if (update.hasBatchCompleted()) {
      for ((index, image) in update.batchCompleted.imagesList.withIndex()) {
        val imageIndex = ((update.currentBatch - 1) * request.batchSize) + (index + 1)
        println("image=$imageIndex format=${image.format.name} data=(${image.data.size()} bytes)")
        val path = Path("work/final_${imageIndex}.${image.format.name}")
        path.writeBytes(image.data.toByteArray())
      }
    }
  }

  channel.shutdownNow()
}

fun prettyProgressValue(value: Float) = String.format("%.2f", value)
