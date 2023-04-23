import Foundation
import GRPC
import NIO
import StableDiffusionCore
import StableDiffusionProtos

struct StableDiffusionClient {
    let group: EventLoopGroup
    let channel: GRPCChannel

    let modelService: SdModelServiceAsyncClient
    let imageGenerationService: SdImageGenerationServiceAsyncClient

    init(connectionTarget: ConnectionTarget, transportSecurity: GRPCChannelPool.Configuration.TransportSecurity) throws {
        group = PlatformSupport.makeEventLoopGroup(loopCount: 1)

        channel = try GRPCChannelPool.with(
            target: connectionTarget,
            transportSecurity: transportSecurity,
            eventLoopGroup: group
        )

        modelService = SdModelServiceAsyncClient(channel: channel)
        imageGenerationService = SdImageGenerationServiceAsyncClient(channel: channel)
    }

    func close() async throws {
        try await group.shutdownGracefully()
    }
}
