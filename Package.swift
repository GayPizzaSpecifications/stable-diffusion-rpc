// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "stable-diffusion-rpc",
    platforms: [.macOS("13.1"), .iOS("16.2")],
    products: [
        .executable(name: "stable-diffusion-rpc", targets: ["StableDiffusionNode"]),
        .library(name: "StableDiffusionProtos", targets: ["StableDiffusionProtos"]),
        .executable(name: "stable-diffusion-ctl", targets: ["StableDiffusionControl"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/ml-stable-diffusion.git", revision: "bef26ae4ff14e6a07551c9e6a1dd25675a830249"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.28.2"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.24.1"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0")
    ],
    targets: [
        .target(name: "StableDiffusionProtos", dependencies: [
            .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            .product(name: "GRPC", package: "grpc-swift")
        ]),
        .target(name: "StableDiffusionCore", dependencies: [
            .product(name: "StableDiffusion", package: "ml-stable-diffusion"),
            .target(name: "StableDiffusionProtos")
        ]),
        .executableTarget(name: "StableDiffusionNode", dependencies: [
            .product(name: "StableDiffusion", package: "ml-stable-diffusion"),
            .product(name: "SwiftProtobuf", package: "swift-protobuf"),
            .product(name: "GRPC", package: "grpc-swift"),
            .target(name: "StableDiffusionProtos"),
            .target(name: "StableDiffusionCore"),
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .executableTarget(name: "StableDiffusionControl", dependencies: [
            .target(name: "StableDiffusionProtos"),
            .target(name: "StableDiffusionCore"),
            .product(name: "GRPC", package: "grpc-swift")
        ])
    ]
)
