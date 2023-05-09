import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

class ModelServiceProvider: SdModelServiceAsyncProvider {
    private let modelManager: ModelManager

    init(modelManager: ModelManager) {
        self.modelManager = modelManager
    }

    func listModels(request _: SdListModelsRequest, context _: GRPCAsyncServerCallContext) async throws -> SdListModelsResponse {
        let models = try await modelManager.listAvailableModels()
        var response = SdListModelsResponse()
        response.availableModels.append(contentsOf: models)
        return response
    }
}
