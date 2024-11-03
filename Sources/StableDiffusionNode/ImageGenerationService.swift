import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

final class ImageGenerationServiceProvider: SdImageGenerationServiceAsyncProvider {
    private let jobManager: JobManager
    private let modelManager: ModelManager

    init(jobManager: JobManager, modelManager: ModelManager) {
        self.jobManager = jobManager
        self.modelManager = modelManager
    }

    func generateImages(request: SdGenerateImagesRequest, context _: GRPCAsyncServerCallContext) async throws -> SdGenerateImagesResponse {
        guard let state = await modelManager.getModelState(name: request.modelName) else {
            throw SdCoreError.modelNotFound
        }
        let job = await jobManager.create()
        DispatchQueue.main.async {
            Task {
                await self.jobManager.updateJobQueued(job)
            }
        }
        return try await state.generate(request, job: job)
    }

    func generateImagesStreaming(request: SdGenerateImagesRequest, responseStream: GRPCAsyncResponseStreamWriter<SdGenerateImagesStreamUpdate>, context _: GRPCAsyncServerCallContext) async throws {
        guard let state = await modelManager.getModelState(name: request.modelName) else {
            throw SdCoreError.modelNotFound
        }
        let job = await jobManager.create()
        DispatchQueue.main.async {
            Task {
                await self.jobManager.updateJobQueued(job)
            }
        }
        _ = try await state.generate(request, job: job, stream: responseStream)
    }
}
