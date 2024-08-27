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
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.5.0"),
        .package(url: "https://github.com/nerdishbynature/octokit.swift", from: "0.13.0"),
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

// MARK: - Upcoming features for Swift 6
// ref: https://github.com/treastrain/swift-upcomingfeatureflags-cheatsheet
private extension SwiftSetting {
    static let forwardTrailingClosures: Self = .enableUpcomingFeature("ForwardTrailingClosures")              // SE-0286, Swift 5.3,  SwiftPM 5.8+
    static let existentialAny: Self = .enableUpcomingFeature("ExistentialAny")                                // SE-0335, Swift 5.6,  SwiftPM 5.8+
    static let bareSlashRegexLiterals: Self = .enableUpcomingFeature("BareSlashRegexLiterals")                // SE-0354, Swift 5.7,  SwiftPM 5.8+
    static let conciseMagicFile: Self = .enableUpcomingFeature("ConciseMagicFile")                            // SE-0274, Swift 5.8,  SwiftPM 5.8+
    static let importObjcForwardDeclarations: Self = .enableUpcomingFeature("ImportObjcForwardDeclarations")  // SE-0384, Swift 5.9,  SwiftPM 5.9+
    static let disableOutwardActorInference: Self = .enableUpcomingFeature("DisableOutwardActorInference")    // SE-0401, Swift 5.9,  SwiftPM 5.9+
    static let deprecateApplicationMain: Self = .enableUpcomingFeature("DeprecateApplicationMain")            // SE-0383, Swift 5.10, SwiftPM 5.10+
    static let isolatedDefaultValues: Self = .enableUpcomingFeature("IsolatedDefaultValues")                  // SE-0411, Swift 5.10, SwiftPM 5.10+
    static let globalConcurrency: Self = .enableUpcomingFeature("GlobalConcurrency")                          // SE-0412, Swift 5.10, SwiftPM 5.10+
}

package.targets.filter { $0.type != .binary }.forEach {
    $0.swiftSettings = [
        // .forwardTrailingClosures,
        .existentialAny,
        .bareSlashRegexLiterals,
        .conciseMagicFile,
        .importObjcForwardDeclarations,
        .disableOutwardActorInference,
        .deprecateApplicationMain,
        .isolatedDefaultValues,
        .globalConcurrency,
    ]
}

// MARK: - Enabling Complete Concurrency Checking for Swift 6
// ref: https://www.swift.org/documentation/concurrency/
package.targets
    .filter { $0.type != .binary }
    .forEach {
        var settings = $0.swiftSettings ?? []
        #if swift(>=6)
        settings.append(.enableUpcomingFeature("StrictConcurrency"))
        #else
        settings.append(.enableExperimentalFeature("StrictConcurrency"))
        #endif
        $0.swiftSettings = settings
        }
