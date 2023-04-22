import Foundation
import GRPC
import NIO
import StableDiffusionProtos
import System

let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
defer {
    try? group.syncShutdownGracefully()
}

let channel = try GRPCChannelPool.with(
    target: .host("localhost", port: 4546),
    transportSecurity: .plaintext,
    eventLoopGroup: group
)

let modelService = SdModelServiceAsyncClient(channel: channel)
let imageGeneratorService = SdImageGenerationServiceAsyncClient(channel: channel)

Task { @MainActor in
    do {
        let modelListResponse = try await modelService.listModels(.init())
        print("Loading model...")
        let modelInfo = modelListResponse.models.first { $0.name == "anything-4.5" }!
        _ = try await modelService.loadModel(.with { request in
            request.modelName = modelInfo.name
        })
        print("Loaded model.")

        print("Generating image...")
        let request = SdGenerateImagesRequest.with {
            $0.modelName = modelInfo.name
            $0.prompt = "cat"
            $0.imageCount = 1
        }

        let response = try await imageGeneratorService.generateImage(request)
        print("Generated image.")
        print(response)
    } catch {
        print(error)
        exit(1)
    }
}

dispatchMain()
