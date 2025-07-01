// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let isDevelop = true

let package = Package(
    name: "SSGH",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "ssgh", targets: ["SSGH"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.1"),
        .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.14.0"),
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
            dependencies: [
                .product(name: "OctoKit", package: "octokit.swift")
            ]
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

if isDevelop {
    #if os(macOS)
    package.dependencies.append(contentsOf: [
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.56.2"),
    ])

    package.targets.filter { $0.type == .regular }.forEach {
        if $0.plugins == nil { $0.plugins = [] }
        $0.plugins?.append(contentsOf: [
            .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins"),
        ])
    }
    #endif
}
