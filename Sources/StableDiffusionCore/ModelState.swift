import CoreML
import Foundation
import GRPC
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
        var pipelineConfig = try toPipelineConfig(request)

        var response = SdGenerateImagesResponse()
        for _ in 0 ..< request.batchCount {
            var seed = baseSeed
            if seed == 0 {
                seed = UInt32.random(in: 0 ..< UInt32.max)
            }
            pipelineConfig.seed = seed
            let images = try pipeline.generateImages(configuration: pipelineConfig)
            try response.images.append(contentsOf: cgImagesToImages(request: request, images))
            response.seeds.append(seed)
        }
        return response
    }

    public func generateStreaming(_ request: SdGenerateImagesRequest, stream: GRPCAsyncResponseStreamWriter<SdGenerateImagesStreamUpdate>) async throws {
        guard let pipeline else {
            throw SdCoreError.modelNotLoaded
        }

        let baseSeed: UInt32 = request.seed
        var pipelineConfig = try toPipelineConfig(request)

        for batch in 1 ... request.batchCount {
            @Sendable func currentOverallPercentage(_ batchPercentage: Float) -> Float {
                let eachSegment = 100.0 / Float(request.batchCount)
                let alreadyCompletedSegments = (Float(batch) - 1) * eachSegment
                let percentageToAdd = eachSegment * (batchPercentage / 100.0)
                return alreadyCompletedSegments + percentageToAdd
            }

            var seed = baseSeed
            if seed == 0 {
                seed = UInt32.random(in: 0 ..< UInt32.max)
            }
            pipelineConfig.seed = seed
            let cgImages = try pipeline.generateImages(configuration: pipelineConfig, progressHandler: { progress in
                let percentage = (Float(progress.step) / Float(progress.stepCount)) * 100.0
                var images: [SdImage]?
                if request.sendIntermediates {
                    images = try? cgImagesToImages(request: request, progress.currentImages)
                }
                let finalImages = images
                Task {
                    try await stream.send(.with { item in
                        item.currentBatch = batch
                        item.batchProgress = .with { update in
                            update.percentageComplete = percentage
                            if let finalImages {
                                update.images = finalImages
                            }
                        }
                        item.overallPercentageComplete = currentOverallPercentage(percentage)
                    })
                }
                return true
            })
            let images = try cgImagesToImages(request: request, cgImages)
            try await stream.send(.with { item in
                item.currentBatch = batch
                item.batchCompleted = .with { update in
                    update.images = images
                    update.seed = seed
                }
                item.overallPercentageComplete = currentOverallPercentage(100.0)
            })
        }
    }

    private func cgImagesToImages(request: SdGenerateImagesRequest, _ cgImages: [CGImage?]) throws -> [SdImage] {
        var images: [SdImage] = []
        for cgImage in cgImages {
            guard let cgImage else { continue }
            try images.append(cgImage.toSdImage(format: request.outputImageFormat))
        }
        return images
    }

    private func toPipelineConfig(_ request: SdGenerateImagesRequest) throws -> StableDiffusionPipeline.Configuration {
        var pipelineConfig = StableDiffusionPipeline.Configuration(prompt: request.prompt)
        pipelineConfig.negativePrompt = request.negativePrompt
        pipelineConfig.imageCount = Int(request.batchSize)

        if request.hasStartingImage {
            pipelineConfig.startingImage = try request.startingImage.toCgImage()
        }

        if request.guidanceScale != 0.0 {
            pipelineConfig.guidanceScale = request.guidanceScale
        }

        if request.stepCount != 0 {
            pipelineConfig.stepCount = Int(request.stepCount)
        }

        if request.strength != 0.0 {
            pipelineConfig.strength = request.strength
        }

        pipelineConfig.disableSafety = !request.enableSafetyCheck

        switch request.scheduler {
        case .pndm: pipelineConfig.schedulerType = .pndmScheduler
        case .dpmSolverPlusPlus: pipelineConfig.schedulerType = .dpmSolverMultistepScheduler
        default: pipelineConfig.schedulerType = .pndmScheduler
        }
        return pipelineConfig
    }

    public func tokenize(_ request: SdTokenizeRequest) throws -> SdTokenizeResponse {
        guard let tokenizer else {
            throw SdCoreError.modelNotLoaded
        }
        let results = tokenizer.tokenize(input: request.input)
        var response = SdTokenizeResponse()
        response.tokens = results.tokens
        response.tokenIds = results.tokenIDs.map { UInt64($0) }
        return response
    }
}
