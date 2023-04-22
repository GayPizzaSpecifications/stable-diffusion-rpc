import Foundation
import GRPC
import StableDiffusionProtos

class ImageGenerationServiceProvider: SdImageGenerationServiceAsyncProvider {
    private let modelManager: ModelManager
    
    init(modelManager: ModelManager) {
        self.modelManager = modelManager
    }
    
    func generateImage(request: SdGenerateImagesRequest, context: GRPCAsyncServerCallContext) async throws -> SdGenerateImagesResponse {
        guard let state = await modelManager.getModelState(name: request.modelName) else {
            throw SdServerError.modelNotFound
        }
        return try await state.generate(request)
    }
}
