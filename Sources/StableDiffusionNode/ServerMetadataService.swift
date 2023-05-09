import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

class ServerMetadataServiceProvider: SdServerMetadataServiceAsyncProvider {
    func getServerMetadata(request _: SdGetServerMetadataRequest, context _: GRPCAsyncServerCallContext) async throws -> SdGetServerMetadataResponse {
        .with { response in
            response.metadata = .with { metadata in
                metadata.role = .node
            }
        }
    }
}
