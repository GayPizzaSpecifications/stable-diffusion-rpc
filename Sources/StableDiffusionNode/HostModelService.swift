import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

class HostModelServiceProvider: SdHostModelServiceAsyncProvider {
    private let modelManager: ModelManager

    init(modelManager: ModelManager) {
        self.modelManager = modelManager
    }

    func loadModel(request: SdLoadModelRequest, context _: GRPCAsyncServerCallContext) async throws -> SdLoadModelResponse {
        let state = try await modelManager.createModelState(name: request.modelName)
        try await state.load(request: request)
        return SdLoadModelResponse()
    }
}
