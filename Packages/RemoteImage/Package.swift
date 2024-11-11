// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RemoteImage",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "RemoteImage",
            targets: ["RemoteImage"]
        ),
    ],
    targets: [
        .target(
            name: "RemoteImage"
        ),
        .target(
            name: "TestMocks"
        ),
        .testTarget(
            name: "RemoteImageTests",
            dependencies: ["RemoteImage", "TestMocks"],
            resources: [.process("Resources")]
        ),
    ]
)
