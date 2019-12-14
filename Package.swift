// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SSGH",
    platforms: [ .macOS(.v10_14) ],
    products: [
        .executable(name: "ssgh", targets: ["SSGH"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander.git", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/ishkawa/APIKit.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/417-72KI/ParameterizedTestUtil.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "SSGH",
            dependencies: ["Commander", "SSGHCore"]),
        .target(
            name: "SSGHCore",
            dependencies: ["GitHubAPI"]
        ),
        .target(
            name: "GitHubAPI",
            dependencies: ["APIKit"]
        ),
        .testTarget(
            name: "SSGHCoreTests",
            dependencies: ["SSGHCore", "ParameterizedTestUtil"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
