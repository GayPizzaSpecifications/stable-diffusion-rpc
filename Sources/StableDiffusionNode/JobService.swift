import Foundation
import GRPC
import StableDiffusionCore
import StableDiffusionProtos

class JobServiceProvider: SdJobServiceAsyncProvider {
    private let jobManager: JobManager

    init(jobManager: JobManager) {
        self.jobManager = jobManager
    }

    func getJob(request: SdGetJobRequest, context _: GRPCAsyncServerCallContext) async throws -> SdGetJobResponse {
        var response = SdGetJobResponse()
        guard let job = await jobManager.job(id: request.id) else {
            throw SdCoreError.jobNotFound
        }
        response.job = job
        return response
    }

    func cancelJob(request _: SdCancelJobRequest, context _: GRPCAsyncServerCallContext) async throws -> SdCancelJobResponse {
        throw SdCoreError.notImplemented
    }

    func streamJobUpdates(request: SdStreamJobUpdatesRequest, responseStream: GRPCAsyncResponseStreamWriter<SdJobUpdate>, context _: GRPCAsyncServerCallContext) async throws {
        let isFilteredById = request.id != 0
        for await job in await jobManager.jobUpdatePublisher {
            if isFilteredById, job.id != request.id {
                continue
            }
            var update = SdJobUpdate()
            update.job = job
            try await responseStream.send(update)
        }
    }
}
