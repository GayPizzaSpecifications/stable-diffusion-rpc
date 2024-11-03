import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

final class TokenizerServiceProvider: SdTokenizerServiceAsyncProvider {
    private let modelManager: ModelManager

    init(modelManager: ModelManager) {
        self.modelManager = modelManager
    }

    func tokenize(request: SdTokenizeRequest, context _: GRPCAsyncServerCallContext) async throws -> SdTokenizeResponse {
        guard let state = await modelManager.getModelState(name: request.modelName) else {
            throw SdCoreError.modelNotFound
        }
        return try await state.tokenize(request)
    }
}
