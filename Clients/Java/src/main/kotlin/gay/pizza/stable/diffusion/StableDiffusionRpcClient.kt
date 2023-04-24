package gay.pizza.stable.diffusion

import io.grpc.Channel

@Suppress("MemberVisibilityCanBePrivate", "unused")
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

  val tokenizerService: TokenizerServiceGrpc.TokenizerServiceStub by lazy {
    TokenizerServiceGrpc.newStub(channel)
  }

  val tokenizerServiceBlocking: TokenizerServiceGrpc.TokenizerServiceBlockingStub by lazy {
    TokenizerServiceGrpc.newBlockingStub(channel)
  }

  val tokenizerServiceFuture: TokenizerServiceGrpc.TokenizerServiceFutureStub by lazy {
    TokenizerServiceGrpc.newFutureStub(channel)
  }

  val tokenizerServiceCoroutine: TokenizerServiceGrpcKt.TokenizerServiceCoroutineStub by lazy {
    TokenizerServiceGrpcKt.TokenizerServiceCoroutineStub(channel)
  }
}
