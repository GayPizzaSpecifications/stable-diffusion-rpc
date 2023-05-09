import Foundation
import GRPC
import NIO
import StableDiffusionCore
import StableDiffusionProtos

struct StableDiffusionClient {
    let group: EventLoopGroup
    let channel: GRPCChannel

    let modelService: SdModelServiceAsyncClient
    let hostModelService: SdHostModelServiceAsyncClient
    let imageGenerationService: SdImageGenerationServiceAsyncClient
    let tokenizerService: SdTokenizerServiceAsyncClient
    let jobService: SdJobServiceAsyncClient
    let serverMetadataService: SdServerMetadataServiceAsyncClient

    init(connectionTarget: ConnectionTarget, transportSecurity: GRPCChannelPool.Configuration.TransportSecurity) throws {
        group = PlatformSupport.makeEventLoopGroup(loopCount: 1)

        channel = try GRPCChannelPool.with(
            target: connectionTarget,
            transportSecurity: transportSecurity,
            eventLoopGroup: group
        )

        modelService = SdModelServiceAsyncClient(channel: channel)
        hostModelService = SdHostModelServiceAsyncClient(channel: channel)
        imageGenerationService = SdImageGenerationServiceAsyncClient(channel: channel)
        tokenizerService = SdTokenizerServiceAsyncClient(channel: channel)
        jobService = SdJobServiceAsyncClient(channel: channel)
        serverMetadataService = SdServerMetadataServiceAsyncClient(channel: channel)
    }

    func close() async throws {
        try await group.shutdownGracefully()
    }
}
