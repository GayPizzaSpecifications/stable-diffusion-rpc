// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "stable-diffusion-rpc",
    platforms: [.macOS("13.1"), .iOS("16.2")],
    products: [
        .executable(name: "stable-diffusion-rpc", targets: ["StableDiffusionServer"]),
        .library(name: "StableDiffusionProtos", targets: ["StableDiffusionProtos"]),
        .executable(name: "stable-diffusion-ctl", targets: ["StableDiffusionControl"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/ml-stable-diffusion", revision: "5d2744e38297b01662b8bdfb41e899ac98036d8b"),
        .package(url: "https://github.com/apple/swift-protobuf", from: "1.6.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.15.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0")
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
        .executableTarget(name: "StableDiffusionServer", dependencies: [
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
