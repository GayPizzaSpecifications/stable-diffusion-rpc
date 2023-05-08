package gay.pizza.stable.diffusion.sample

import com.google.protobuf.ByteString
import gay.pizza.stable.diffusion.*
import io.grpc.ManagedChannelBuilder
import io.grpc.stub.StreamObserver
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.runBlocking
import java.nio.file.Path
import java.util.concurrent.atomic.AtomicInteger
import kotlin.io.path.*
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

  val jobs = mutableMapOf<Long, Job>()

  client.jobService.streamJobUpdates(StreamJobUpdatesRequest.getDefaultInstance(), object : StreamObserver<JobUpdate> {
    override fun onNext(value: JobUpdate) {
      jobs[value.job.id] = value.job
      jobs.values.map {
        "job=${it.id} status=${it.state.name} completion=${it.overallPercentageComplete}"
      }.forEach(::println)
    }

    override fun onError(throwable: Throwable) {
      throwable.printStackTrace()
      exitProcess(1)
    }

    override fun onCompleted() {}
  })

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

  val workingDirectory = Path("work")
  if (!workingDirectory.exists()) {
    workingDirectory.createDirectories()
  }

  runBlocking {
    val task1 = async {
      performImageGeneration(1, client, request, workingDirectory.resolve("task1"))
    }

    val task2 = async {
      performImageGeneration(2, client, request, workingDirectory.resolve("task2"))
    }

    awaitAll(task1, task2)
  }

  channel.shutdownNow()
}

@OptIn(ExperimentalPathApi::class)
suspend fun performImageGeneration(task: Int, client: StableDiffusionRpcClient, request: GenerateImagesRequest, path: Path) {
  val updateIndex = AtomicInteger(0)
  if (path.exists()) {
    path.deleteRecursively()
  }
  path.createDirectories()

  client.imageGenerationServiceCoroutine.generateImagesStreaming(request).collect { update ->
    updateIndex.incrementAndGet()
    if (update.hasBatchProgress()) {
      println("task=$task batch=${update.currentBatch} " +
        "progress=${prettyProgressValue(update.batchProgress.percentageComplete)}% " +
        "overall=${prettyProgressValue(update.overallPercentageComplete)}%")
      for ((index, image) in update.batchProgress.imagesList.withIndex()) {
        val imageIndex = ((update.currentBatch - 1) * request.batchSize) + (index + 1)
        println("task=$task image=$imageIndex update=$updateIndex format=${image.format.name} data=(${image.data.size()} bytes)")
        val filePath = path.resolve("intermediate_${imageIndex}_${updateIndex}.${image.format.name}")
        filePath.writeBytes(image.data.toByteArray())
      }
    }

    if (update.hasBatchCompleted()) {
      for ((index, image) in update.batchCompleted.imagesList.withIndex()) {
        val imageIndex = ((update.currentBatch - 1) * request.batchSize) + (index + 1)
        println("task=$task image=$imageIndex format=${image.format.name} data=(${image.data.size()} bytes)")
        val filePath = path.resolve("final_${imageIndex}.${image.format.name}")
        filePath.writeBytes(image.data.toByteArray())
      }
    }
  }
}

fun prettyProgressValue(value: Float) = String.format("%.2f", value)
