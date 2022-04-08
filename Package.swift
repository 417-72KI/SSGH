// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSGH",
    platforms: [ .macOS(.v10_14) ],
    products: [
        .executable(name: "ssgh", targets: ["SSGH"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.1.1")),
        .package(url: "https://github.com/ishkawa/APIKit.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/AliSoftware/OHHTTPStubs.git", .upToNextMajor(from: "9.0.0")),
        // .package(name: "OctoKit", url: "https://github.com/nerdishbynature/octokit.swift", from: "0.11.0"),
        .package(name: "OctoKit", url: "https://github.com/417-72KI/octokit.swift", revision: "02ac971"),
        .package(url: "https://github.com/417-72KI/ParameterizedTestUtil.git", .upToNextMajor(from: "1.0.0"))
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
            dependencies: ["APIKit", "OctoKit"]
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
            dependencies: [
                "GitHubAPI",
                .product(name: "OHHTTPStubsSwift", package: "OHHTTPStubs")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)
