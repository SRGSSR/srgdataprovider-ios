// swift-tools-version:5.3

import PackageDescription

struct ProjectSettings {
    static let marketingVersion: String = "9.0.0"
}

let package = Package(
    name: "SRGDataProvider",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v9),
        .tvOS(.v12),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "SRGDataProviderNetwork",
            targets: ["SRGDataProviderNetwork"]
        ),
        .library(
            name: "SRGDataProviderCombine",
            targets: ["SRGDataProviderCombine"]
        )
    ],
    dependencies: [
        .package(name: "libextobjc", url: "https://github.com/SRGSSR/libextobjc.git", .branch("master")),
        .package(name: "Mantle", url: "https://github.com/Mantle/Mantle.git", .upToNextMinor(from: "2.1.5")),
        .package(name: "SRGNetwork", url: "https://github.com/SRGSSR/srgnetwork-apple.git", .branch("develop"))
    ],
    targets: [
        .target(
            name: "SRGDataProvider",
            cSettings: [
                .define("MARKETING_VERSION", to: "\"\(ProjectSettings.marketingVersion)\"")
            ]
        ),
        .target(
            name: "SRGDataProviderModel",
            dependencies: ["libextobjc", "Mantle"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "SRGDataProviderRequests",
            dependencies: ["SRGDataProvider", "SRGDataProviderModel"]
        ),
        .target(
            name: "SRGDataProviderNetwork",
            dependencies: ["SRGDataProviderRequests", "SRGNetwork"]
        ),
        .target(
            name: "SRGDataProviderCombine",
            dependencies: ["SRGDataProviderRequests", "SRGNetwork"]
        ),
        .testTarget(
            name: "SRGDataProviderTests",
            dependencies: ["SRGDataProvider"]
        ),
        .testTarget(
            name: "SRGDataProviderModelTests",
            dependencies: ["SRGDataProviderModel"],
            cSettings: [
                .headerSearchPath("Private")
            ]
        ),
        .testTarget(
            name: "SRGDataProviderNetworkTests",
            dependencies: ["SRGDataProviderNetwork"]
        ),
        .testTarget(
            name: "SRGDataProviderCombineTests",
            dependencies: ["SRGDataProviderCombine"]
        )
    ]
)
