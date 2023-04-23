package gay.pizza.stable.diffusion.sample

import gay.pizza.stable.diffusion.StableDiffusion
import gay.pizza.stable.diffusion.StableDiffusion.GenerateImagesRequest
import gay.pizza.stable.diffusion.StableDiffusion.ListModelsRequest
import gay.pizza.stable.diffusion.StableDiffusion.LoadModelRequest
import gay.pizza.stable.diffusion.StableDiffusionRpcClient
import io.grpc.ManagedChannelBuilder
import kotlin.io.path.Path
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

  val request = GenerateImagesRequest.newBuilder().apply {
    modelName = model.name
    outputImageFormat = StableDiffusion.ImageFormat.png
    batchSize = 2
    batchCount = 2
    prompt = "cat"
    negativePrompt = "bad, low quality, nsfw"
  }.build()
  val generateImagesResponse = client.imageGenerationServiceBlocking.generateImages(request)

  println("generated ${generateImagesResponse.imagesCount} images:")
  for ((index, image) in generateImagesResponse.imagesList.withIndex()) {
    println("  image ${index + 1} format=${image.format.name} data=(${image.data.size()} bytes)")
    val path = Path("work/image${index}.${image.format.name}")
    path.writeBytes(image.data.toByteArray())
  }

  channel.shutdownNow()
}
