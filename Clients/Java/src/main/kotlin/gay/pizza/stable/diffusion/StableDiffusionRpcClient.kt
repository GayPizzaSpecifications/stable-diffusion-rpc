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

  val hostModelService: HostModelServiceGrpc.HostModelServiceStub by lazy {
    HostModelServiceGrpc.newStub(channel)
  }

  val hostModelServiceBlocking: HostModelServiceGrpc.HostModelServiceBlockingStub by lazy {
    HostModelServiceGrpc.newBlockingStub(channel)
  }

  val hostModelServiceFuture: HostModelServiceGrpc.HostModelServiceFutureStub by lazy {
    HostModelServiceGrpc.newFutureStub(channel)
  }

  val hostModelServiceCoroutine: HostModelServiceGrpcKt.HostModelServiceCoroutineStub by lazy {
    HostModelServiceGrpcKt.HostModelServiceCoroutineStub(channel)
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

  val jobService: JobServiceGrpc.JobServiceStub by lazy {
    JobServiceGrpc.newStub(channel)
  }

  val jobServiceBlocking: JobServiceGrpc.JobServiceBlockingStub by lazy {
    JobServiceGrpc.newBlockingStub(channel)
  }

  val jobServiceFuture: JobServiceGrpc.JobServiceFutureStub by lazy {
    JobServiceGrpc.newFutureStub(channel)
  }

  val jobServiceCoroutine: JobServiceGrpcKt.JobServiceCoroutineStub by lazy {
    JobServiceGrpcKt.JobServiceCoroutineStub(channel)
  }
}
