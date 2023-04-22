import Foundation
import GRPC
import StableDiffusionProtos

class ModelServiceProvider: SdModelServiceAsyncProvider {
    private let modelManager: ModelManager
    
    init(modelManager: ModelManager) {
        self.modelManager = modelManager
    }
    
    func listModels(request: SdListModelsRequest, context: GRPCAsyncServerCallContext) async throws -> SdListModelsResponse {
        let models = await modelManager.listModels()
        var response = SdListModelsResponse()
        response.models.append(contentsOf: models)
        return response
    }
    
    func reloadModels(request: SdReloadModelsRequest, context: GRPCAsyncServerCallContext) async throws -> SdReloadModelsResponse {
        try await modelManager.reloadModels()
        return SdReloadModelsResponse()
    }
    
    func loadModel(request: SdLoadModelRequest, context: GRPCAsyncServerCallContext) async throws -> SdLoadModelResponse {
        guard let state = await modelManager.getModelState(name: request.modelName) else {
            throw SdServerError.modelNotFound
        }
        try await state.load()
        return SdLoadModelResponse()
    }
}
