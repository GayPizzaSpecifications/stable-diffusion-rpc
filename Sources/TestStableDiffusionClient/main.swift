import Foundation
import GRPC
import NIO
import StableDiffusionProtos
import System

let client = try StableDiffusionClient(connectionTarget: .host("127.0.0.1", port: 4546), transportSecurity: .plaintext)

Task { @MainActor in
    do {
        let modelListResponse = try await client.modelService.listModels(.init())
        print("Loading model...")
        let modelInfo = modelListResponse.models.first { $0.name == "anything-4.5" }!
        _ = try await client.modelService.loadModel(.with { request in
            request.modelName = modelInfo.name
        })
        print("Loaded model.")

        print("Generating image...")
        let request = SdGenerateImagesRequest.with {
            $0.modelName = modelInfo.name
            $0.prompt = "cat"
            $0.imageCount = 1
        }

        let response = try await client.imageGenerationService.generateImage(request)
        let image = response.images.first!
        try image.content.write(to: URL(filePath: "output.png"))
        print("Generated image to output.png")
        exit(0)
    } catch {
        print(error)
        exit(1)
    }
}

dispatchMain()
