import CoreML
import Foundation
import StableDiffusion
import StableDiffusionProtos

public actor ModelState {
    private let url: URL
    private var pipeline: StableDiffusionPipeline?
    private var tokenizer: BPETokenizer?

    public init(url: URL) {
        self.url = url
    }

    public func load() throws {
        let config = MLModelConfiguration()
        config.computeUnits = .cpuAndGPU
        pipeline = try StableDiffusionPipeline(
            resourcesAt: url,
            controlNet: [],
            configuration: config,
            disableSafety: true,
            reduceMemory: false
        )
        let mergesUrl = url.appending(component: "merges.txt")
        let vocabUrl = url.appending(component: "vocab.json")
        tokenizer = try BPETokenizer(mergesAt: mergesUrl, vocabularyAt: vocabUrl)
        try pipeline?.loadResources()
    }

    public func generate(_ request: SdGenerateImagesRequest) throws -> SdGenerateImagesResponse {
        guard let pipeline else {
            throw SdCoreError.modelNotLoaded
        }

        var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: request.prompt)
        pipelineConfig.negativePrompt = request.negativePrompt
        pipelineConfig.seed = UInt32.random(in: 0 ..< UInt32.max)

        var response = SdGenerateImagesResponse()
        for _ in 0 ..< request.imageCount {
            let images = try pipeline.generateImages(configuration: pipelineConfig)

            for cgImage in images {
                guard let cgImage else { continue }
                var image = SdImage()
                image.content = try cgImage.toPngData()
                response.images.append(image)
            }
        }
        return response
    }
}
