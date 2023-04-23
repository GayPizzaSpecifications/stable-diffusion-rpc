import CoreML
import Foundation

public extension SdComputeUnits {
    func toMlComputeUnits() -> MLComputeUnits {
        switch self {
        case .all: return .all
        case .cpu: return .cpuOnly
        case .cpuAndGpu: return .cpuAndGPU
        case .cpuAndNeuralEngine: return .cpuAndNeuralEngine
        default: return .all
        }
    }
}

public extension MLComputeUnits {
    func toSdComputeUnits() -> SdComputeUnits {
        switch self {
        case .all: return .all
        case .cpuOnly: return .cpu
        case .cpuAndGPU: return .cpuAndGpu
        case .cpuAndNeuralEngine: return .cpuAndNeuralEngine
        default: return .all
        }
    }
}
