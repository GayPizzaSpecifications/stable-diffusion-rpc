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
        let models = await modelManager.listModels()
        var response = SdListModelsResponse()
        response.models.append(contentsOf: models)
        return response
    }

    func reloadModels(request _: SdReloadModelsRequest, context _: GRPCAsyncServerCallContext) async throws -> SdReloadModelsResponse {
        try await modelManager.reloadModels()
        return SdReloadModelsResponse()
    }

    func loadModel(request: SdLoadModelRequest, context _: GRPCAsyncServerCallContext) async throws -> SdLoadModelResponse {
        let state = try await modelManager.createModelState(name: request.modelName)
        try await state.load()
        return SdLoadModelResponse()
    }
}
