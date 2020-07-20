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
        .package(name: "Mantle", url: "https://github.com/SRGSSR/Mantle.git", .branch("swift-package-manager-support")),
        .package(name: "SRGNetwork", url: "https://github.com/SRGSSR/srgnetwork-apple.git", .branch("feature/spm-support"))
    ],
    targets: [
        .target(
            name: "SRGDataProvider",
            dependencies: ["Mantle", "SRGNetwork"],
            resources: [
                .process("Resources")
            ],
            cSettings: [
                .define("MARKETING_VERSION", to: "\"\(ProjectSettings.marketingVersion)\"")
            ]
        ),
        .testTarget(
            name: "SRGDataProviderTests",
            dependencies: ["SRGDataProvider"],
            cSettings: [
                .headerSearchPath("Private")
            ]
        )
    ]
)
