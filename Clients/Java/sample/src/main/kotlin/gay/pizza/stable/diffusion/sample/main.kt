package gay.pizza.stable.diffusion.sample

import com.google.protobuf.ByteString
import gay.pizza.stable.diffusion.StableDiffusion
import gay.pizza.stable.diffusion.StableDiffusion.GenerateImagesRequest
import gay.pizza.stable.diffusion.StableDiffusion.Image
import gay.pizza.stable.diffusion.StableDiffusion.ListModelsRequest
import gay.pizza.stable.diffusion.StableDiffusion.LoadModelRequest
import gay.pizza.stable.diffusion.StableDiffusionRpcClient
import io.grpc.ManagedChannelBuilder
import kotlin.io.path.Path
import kotlin.io.path.exists
import kotlin.io.path.readBytes
import kotlin.io.path.writeBytes
import kotlin.system.exitProcess

fun main() {
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

  val model = modelListResponse.availableModelsList.random()
  if (!model.isLoaded) {
    println("loading model ${model.name}...")
    client.modelServiceBlocking.loadModel(LoadModelRequest.newBuilder().apply {
      modelName = model.name
      computeUnits = model.supportedComputeUnitsList.first()
    }.build())
  } else {
    println("using model ${model.name}...")
  }

  println("generating images...")

  val startingImagePath = Path("work/start.png")

  val request = GenerateImagesRequest.newBuilder().apply {
    modelName = model.name
    outputImageFormat = StableDiffusion.ImageFormat.png
    batchSize = 2
    batchCount = 2
    prompt = "cat"
    negativePrompt = "bad, low quality, nsfw"
    if (startingImagePath.exists()) {
      val image = Image.newBuilder().apply {
        format = StableDiffusion.ImageFormat.png
        data = ByteString.copyFrom(startingImagePath.readBytes())
      }.build()

      startingImage = image
    }
  }.build()
  for (update in client.imageGenerationServiceBlocking.generateImagesStreaming(request)) {
    if (update.hasBatchProgress()) {
      println("batch ${update.currentBatch} progress ${update.batchProgress.percentageComplete}%")
    }

    if (update.hasBatchCompleted()) {
      for ((index, image) in update.batchCompleted.imagesList.withIndex()) {
        val imageIndex = ((update.currentBatch - 1) * request.batchSize) + (index + 1)
        println("image $imageIndex format=${image.format.name} data=(${image.data.size()} bytes)")
        val path = Path("work/image${imageIndex}.${image.format.name}")
        path.writeBytes(image.data.toByteArray())
      }
    }
    println("overall progress ${update.overallPercentageComplete}%")
  }

  channel.shutdownNow()
}
