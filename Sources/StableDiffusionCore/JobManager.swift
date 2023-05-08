import Combine
import Foundation
import StableDiffusionProtos

public typealias JobUpdateSubject = PassthroughSubject<SdJob, Never>

public actor JobManager {
    public let jobUpdateSubject = JobUpdateSubject()
    public let jobUpdatePublisher: AsyncPublisher<JobUpdateSubject>

    private var jobs: [UInt64: SdJob] = [:]
    private var id: UInt64 = 0

    public init() {
        jobUpdatePublisher = AsyncPublisher(jobUpdateSubject)
    }

    func nextId() -> UInt64 {
        id += 1
        return id
    }

    public func create() -> SdJob {
        var job = SdJob()
        job.id = nextId()
        job.state = .queued
        jobs[job.id] = job
        return job
    }

    public func job(id: UInt64) -> SdJob? {
        guard let job = jobs[id] else {
            return nil
        }
        return try? SdJob(serializedData: job.serializedData())
    }

    public func updateJobQueued(_ job: SdJob) {
        guard var stored = jobs[job.id] else {
            return
        }
        stored.state = .queued
        jobUpdateSubject.send(stored)
        jobs[job.id] = stored
    }

    public func updateJobProgress(_ job: SdJob, progress: Float) {
        guard var stored = jobs[job.id] else {
            return
        }
        stored.state = .running
        stored.overallPercentageComplete = progress
        jobUpdateSubject.send(stored)
        jobs[job.id] = stored
    }

    public func updateJobCompleted(_ job: SdJob) {
        guard var stored = jobs[job.id] else {
            return
        }
        stored.state = .completed
        stored.overallPercentageComplete = 100.0
        jobUpdateSubject.send(stored)
        jobs[job.id] = stored
    }

    public func updateJobRunning(_ job: SdJob) {
        guard var stored = jobs[job.id] else {
            return
        }
        stored.state = .running
        stored.overallPercentageComplete = 0.0
        jobUpdateSubject.send(stored)
        jobs[job.id] = stored
    }

    public func listAllJobs() -> [SdJob] {
        var copy: [SdJob] = []
        for item in jobs.values {
            guard let job = try? SdJob(serializedData: item.serializedData()) else {
                continue
            }
            copy.append(job)
        }
        return copy
    }
}
