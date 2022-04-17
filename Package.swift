// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSGH",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "ssgh", targets: ["SSGH"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.2"),
        // .package(name: "OctoKit", url: "https://github.com/nerdishbynature/octokit.swift", from: "0.11.0"),
        .package(name: "OctoKit", url: "https://github.com/nerdishbynature/octokit.swift", revision: "8f78b18"),
        .package(url: "https://github.com/417-72KI/ParameterizedTestUtil.git", from: "1.0.0")
    ],
    targets: [
        .executableTarget(
            name: "SSGH",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SSGHCore"
            ]
        ),
        .target(
            name: "SSGHCore",
            dependencies: ["GitHubAPI"]
        ),
        .target(
            name: "GitHubAPI",
            dependencies: ["OctoKit"]
        ),
        .testTarget(
            name: "SSGHTests",
            dependencies: ["SSGH"]
        ),
        .testTarget(
            name: "SSGHCoreTests",
            dependencies: [
                "SSGHCore",
                "ParameterizedTestUtil"
            ]
        ),
        .testTarget(
            name: "GitHubAPITests",
            dependencies: ["GitHubAPI"],
            resources: [.copy("Resources")]
        )
    ],
    swiftLanguageVersions: [.v5]
)
