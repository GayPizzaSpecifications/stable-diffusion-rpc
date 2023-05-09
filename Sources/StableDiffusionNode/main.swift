import ArgumentParser
import Foundation
import GRPC
import NIO
import StableDiffusionCore
import System

struct ServerCommand: ParsableCommand {
    @Option(name: .shortAndLong, help: "Path to models directory")
    var modelsDirectoryPath: String = "models"

    @Option(name: .long, help: "Bind host")
    var bindHost: String = "0.0.0.0"

    @Option(name: .long, help: "Bind port")
    var bindPort: Int = 4546

    mutating func run() throws {
        let jobManager = JobManager()
        let modelsDirectoryURL = URL(filePath: modelsDirectoryPath)
        let modelManager = ModelManager(modelBaseURL: modelsDirectoryURL, jobManager: jobManager)

        let semaphore = DispatchSemaphore(value: 0)
        Task {
            do {
                try await modelManager.reloadAvailableModels()
            } catch {
                ServerCommand.exit(withError: error)
            }
            semaphore.signal()
        }
        semaphore.wait()

        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        _ = Server.insecure(group: group)
            .withServiceProviders([
                ModelServiceProvider(modelManager: modelManager),
                HostModelServiceProvider(modelManager: modelManager),
                ImageGenerationServiceProvider(jobManager: jobManager, modelManager: modelManager),
                TokenizerServiceProvider(modelManager: modelManager),
                JobServiceProvider(jobManager: jobManager),
                ServerMetadataServiceProvider()
            ])
            .bind(host: bindHost, port: bindPort)

        print("Stable Diffusion RPC node running on \(bindHost):\(bindPort)")

        dispatchMain()
    }
}

ServerCommand.main()
