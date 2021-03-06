// swift-tools-version:5.3

import PackageDescription

struct ProjectSettings {
    static let marketingVersion: String = "11.0.0"
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
        .package(name: "libextobjc", url: "https://github.com/SRGSSR/libextobjc.git", .exact("0.6.0-srg3")),
        .package(name: "Mantle", url: "https://github.com/Mantle/Mantle.git", .upToNextMinor(from: "2.1.6")),
        .package(name: "SRGNetwork", url: "https://github.com/SRGSSR/srgnetwork-apple.git", .upToNextMinor(from: "3.0.0"))
    ],
    targets: [
        .target(
            name: "SRGDataProvider",
            cSettings: [
                .define("MARKETING_VERSION", to: "\"\(ProjectSettings.marketingVersion)\""),
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
        ),
        .target(
            name: "SRGDataProviderModel",
            dependencies: ["libextobjc", "Mantle"],
            resources: [
                .process("Resources")
            ],
            cSettings:[
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
        ),
        .target(
            name: "SRGDataProviderRequests",
            dependencies: ["SRGDataProvider", "SRGDataProviderModel"],
            cSettings:[
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
        ),
        .target(
            name: "SRGDataProviderNetwork",
            dependencies: ["SRGDataProviderRequests", "SRGNetwork"],
            cSettings:[
                .define("NS_BLOCK_ASSERTIONS", to: "1", .when(configuration: .release))
            ]
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
