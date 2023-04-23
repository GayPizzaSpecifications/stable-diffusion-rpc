package gay.pizza.stable.diffusion.sample

import gay.pizza.stable.diffusion.StableDiffusion.GenerateImagesRequest
import gay.pizza.stable.diffusion.StableDiffusion.ListModelsRequest
import gay.pizza.stable.diffusion.StableDiffusion.LoadModelRequest
import gay.pizza.stable.diffusion.StableDiffusionRpcClient
import io.grpc.ManagedChannelBuilder
import kotlin.system.exitProcess

fun main() {
  val channel = ManagedChannelBuilder
    .forAddress("127.0.0.1", 4546)
    .usePlaintext()
    .build()

  val client = StableDiffusionRpcClient(channel)
  val modelListResponse = client.modelServiceBlocking.listModels(ListModelsRequest.getDefaultInstance())
  if (modelListResponse.modelsList.isEmpty()) {
    println("no available models")
    exitProcess(0)
  }
  println("available models:")
  for (model in modelListResponse.modelsList) {
    println("  model ${model.name} attention=${model.attention} loaded=${model.isLoaded}")
  }

  val model = modelListResponse.modelsList.random()
  if (!model.isLoaded) {
    println("loading model ${model.name}...")
    client.modelServiceBlocking.loadModel(LoadModelRequest.newBuilder().apply {
      modelName = model.name
    }.build())
  } else {
    println("using model ${model.name}...")
  }

  println("generating images...")

  val generateImagesResponse = client.imageGenerationServiceBlocking.generateImage(GenerateImagesRequest.newBuilder().apply {
    modelName = model.name
    imageCount = 1
    prompt = "cat"
    negativePrompt = "bad, low quality, nsfw"
  }.build())

  println("generated ${generateImagesResponse.imagesCount} images")

  channel.shutdownNow()
}
