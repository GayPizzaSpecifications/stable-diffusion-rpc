import Foundation
import ArgumentParser
import GRPC
import NIO
import System

struct ServerCommand: ParsableCommand {
    @Option(name: .shortAndLong, help: "Path to models directory")
    var modelsDirectoryPath: String = "models"
    
    mutating func run() throws {
        let modelsDirectoryURL = URL(filePath: modelsDirectoryPath)
        let modelManager = ModelManager(modelBaseURL: modelsDirectoryURL)
        
        let semaphore = DispatchSemaphore(value: 0)
        Task {
            print("Loading initial models...")
            do {
                try await modelManager.reloadModels()
            } catch {
                ServerCommand.exit(withError: error)
            }
            print("Loaded initial models.")
            semaphore.signal()
        }
        semaphore.wait()

        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        _ = Server.insecure(group: group)
            .withServiceProviders([
                ModelServiceProvider(modelManager: modelManager),
                ImageGenerationServiceProvider(modelManager: modelManager)
            ])
            .bind(host: "0.0.0.0", port: 4546)
        
        dispatchMain()
    }

}
ServerCommand.main()
