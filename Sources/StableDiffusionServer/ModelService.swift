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

    func loadModel(request: SdLoadModelRequest, context _: GRPCAsyncServerCallContext) async throws -> SdLoadModelResponse {
        let state = try await modelManager.createModelState(name: request.modelName)
        try await state.load(request: request)
        return SdLoadModelResponse()
    }
}
