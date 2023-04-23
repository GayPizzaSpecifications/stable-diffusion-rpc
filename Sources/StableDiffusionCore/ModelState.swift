import CoreML
import Foundation
import StableDiffusion
import StableDiffusionProtos

public actor ModelState {
    private let url: URL
    private var pipeline: StableDiffusionPipeline?
    private var tokenizer: BPETokenizer?
    private var loadedConfiguration: MLModelConfiguration?

    public init(url: URL) {
        self.url = url
    }

    public func load(request: SdLoadModelRequest) throws {
        let config = MLModelConfiguration()
        config.computeUnits = request.computeUnits.toMlComputeUnits()
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
        loadedConfiguration = config
    }

    public func isModelLoaded() -> Bool {
        pipeline != nil
    }

    public func loadedModelComputeUnits() -> SdComputeUnits? {
        loadedConfiguration?.computeUnits.toSdComputeUnits()
    }

    public func generate(_ request: SdGenerateImagesRequest) throws -> SdGenerateImagesResponse {
        guard let pipeline else {
            throw SdCoreError.modelNotLoaded
        }

        let baseSeed: UInt32 = request.seed

        var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: request.prompt)
        pipelineConfig.negativePrompt = request.negativePrompt
        pipelineConfig.imageCount = Int(request.batchSize)
        var response = SdGenerateImagesResponse()
        for _ in 0 ..< request.batchCount {
            var seed = baseSeed
            if seed == 0 {
                seed = UInt32.random(in: 0 ..< UInt32.max)
            }
            pipelineConfig.seed = seed
            let images = try pipeline.generateImages(configuration: pipelineConfig)

            for cgImage in images {
                guard let cgImage else { continue }
                try response.images.append(cgImage.toSdImage(format: request.outputImageFormat))
            }
            response.seeds.append(seed)
        }
        return response
    }
}
