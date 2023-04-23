import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

class ImageGenerationServiceProvider: SdImageGenerationServiceAsyncProvider {
    private let modelManager: ModelManager

    init(modelManager: ModelManager) {
        self.modelManager = modelManager
    }

    func generateImages(request: SdGenerateImagesRequest, context _: GRPCAsyncServerCallContext) async throws -> SdGenerateImagesResponse {
        guard let state = await modelManager.getModelState(name: request.modelName) else {
            throw SdCoreError.modelNotFound
        }
        return try await state.generate(request)
    }
}
