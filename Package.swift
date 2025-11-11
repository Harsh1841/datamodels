// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "datamodels",
    platforms: [
        .macOS(.v13) // WhisperKit requires macOS 13+
    ],
    dependencies: [
        .package(url: "https://github.com/argmaxinc/WhisperKit", from: "0.5.0")
    ],
    targets: [
        .executableTarget(
            name: "datamodels",
            dependencies: [
                .product(name: "WhisperKit", package: "WhisperKit")
            ],
            linkerSettings: [
                .linkedFramework("Speech")
            ]
        ),
        .testTarget(
            name: "datamodelsTests",
            dependencies: ["datamodels"]
        )
    ]
)
