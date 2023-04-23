package gay.pizza.stable.diffusion

import io.grpc.Channel

@Suppress("MemberVisibilityCanBePrivate")
class StableDiffusionRpcClient(val channel: Channel) {
  val modelService: ModelServiceGrpc.ModelServiceStub by lazy {
    ModelServiceGrpc.newStub(channel)
  }

  val modelServiceBlocking: ModelServiceGrpc.ModelServiceBlockingStub by lazy {
    ModelServiceGrpc.newBlockingStub(channel)
  }

  val modelServiceFuture: ModelServiceGrpc.ModelServiceFutureStub by lazy {
    ModelServiceGrpc.newFutureStub(channel)
  }

  val modelServiceCoroutine: ModelServiceGrpcKt.ModelServiceCoroutineStub by lazy {
    ModelServiceGrpcKt.ModelServiceCoroutineStub(channel)
  }

  val imageGenerationService: ImageGenerationServiceGrpc.ImageGenerationServiceStub by lazy {
    ImageGenerationServiceGrpc.newStub(channel)
  }

  val imageGenerationServiceBlocking: ImageGenerationServiceGrpc.ImageGenerationServiceBlockingStub by lazy {
    ImageGenerationServiceGrpc.newBlockingStub(channel)
  }

  val imageGenerationServiceFuture: ImageGenerationServiceGrpc.ImageGenerationServiceFutureStub by lazy {
    ImageGenerationServiceGrpc.newFutureStub(channel)
  }

  val imageGenerationServiceCoroutine: ImageGenerationServiceGrpcKt.ImageGenerationServiceCoroutineStub by lazy {
    ImageGenerationServiceGrpcKt.ImageGenerationServiceCoroutineStub(channel)
  }
}
