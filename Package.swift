// swift-tools-version:5.3

import PackageDescription

struct ProjectSettings {
    static let marketingVersion: String = "8.0.2"
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
            name: "SRGDataProvider",
            targets: ["SRGDataProvider"]
        )
    ],
    dependencies: [
        .package(name: "libextobjc", url: "https://github.com/SRGSSR/libextobjc.git", .branch("feature/spm-support")),
        .package(name: "Mantle", url: "https://github.com/SRGSSR/Mantle.git", .branch("swift-package-manager-support")),
        .package(name: "SRGNetwork", url: "https://github.com/SRGSSR/srgnetwork-apple.git", .branch("feature/spm-support"))
    ],
    targets: [
        .target(
            name: "SRGDataProviderModel",
            dependencies: ["libextobjc", "Mantle", "SRGNetwork"],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "SRGDataProvider",
            dependencies: ["SRGDataProviderModel"],
            cSettings: [
                .define("MARKETING_VERSION", to: "\"\(ProjectSettings.marketingVersion)\"")
            ]
        ),
        .target(
            name: "SRGDataProviderCombine",
            dependencies: ["SRGDataProviderModel"]
        ),
        .testTarget(
            name: "SRGDataProviderTests",
            dependencies: ["SRGDataProvider"],
            cSettings: [
                .headerSearchPath("Private")
            ]
        ),
        .testTarget(
            name: "SRGDataProviderCombineTests",
            dependencies: ["SRGDataProviderCombine"]
        )
    ]
)
