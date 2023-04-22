import Foundation
import StableDiffusion
import StableDiffusionProtos

public actor ModelManager {
    private var modelInfos: [String: SdModelInfo] = [:]
    private var modelUrls: [String: URL] = [:]
    private var modelStates: [String: ModelState] = [:]

    private let modelBaseURL: URL

    public init(modelBaseURL: URL) {
        self.modelBaseURL = modelBaseURL
    }

    public func reloadModels() throws {
        modelInfos.removeAll()
        modelUrls.removeAll()
        modelStates.removeAll()
        let contents = try FileManager.default.contentsOfDirectory(at: modelBaseURL.resolvingSymlinksInPath(), includingPropertiesForKeys: [.isDirectoryKey])
        for subdirectoryURL in contents {
            let values = try subdirectoryURL.resourceValues(forKeys: [.isDirectoryKey])
            if values.isDirectory ?? false {
                try addModel(url: subdirectoryURL)
            }
        }
    }

    public func listModels() -> [SdModelInfo] {
        Array(modelInfos.values)
    }

    public func createModelState(name: String) throws -> ModelState {
        let state = modelStates[name]
        let url = modelUrls[name]
        guard let url else {
            throw SdCoreError.modelNotFound
        }

        if state == nil {
            let state = ModelState(url: url)
            modelStates[name] = state
            return state
        } else {
            return state!
        }
    }

    public func getModelState(name: String) -> ModelState? {
        modelStates[name]
    }

    private func addModel(url: URL) throws {
        var info = SdModelInfo()
        info.name = url.lastPathComponent
        let attention = getModelAttention(url)
        info.attention = attention ?? "unknown"
        modelInfos[info.name] = info
        modelUrls[info.name] = url
    }

    private func getModelAttention(_ url: URL) -> String? {
        let unetMetadataURL = url.appending(components: "Unet.mlmodelc", "metadata.json")

        struct ModelMetadata: Decodable {
            let mlProgramOperationTypeHistogram: [String: Int]
        }

        do {
            let jsonData = try Data(contentsOf: unetMetadataURL)
            let metadatas = try JSONDecoder().decode([ModelMetadata].self, from: jsonData)

            guard metadatas.count == 1 else {
                return nil
            }

            return metadatas[0].mlProgramOperationTypeHistogram["Ios16.einsum"] != nil ? "split-einsum" : "original"
        } catch {
            return nil
        }
    }
}
