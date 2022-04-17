import XCTest
import SSGHCore
import ArgumentParser

final class SSGHTests: XCTestCase {
    func testBinary() throws {
        try context("version") {
            let pipe = Pipe()
            let process = process(
                withArguments: ["--version"],
                pipe: pipe
            )
            XCTAssertNoThrow(try process.run())
            process.waitUntilExit()
            XCTAssertEqual(ExitCode(process.terminationStatus), .success)
            let version = try XCTUnwrap(String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?.trimmingCharacters(in: .newlines))
            XCTAssertEqual(Version(version), ApplicationInfo.version)
        }
    }
}

private extension SSGHTests {
    /// Returns path to the built products directory.
    static var productsDirectory: URL {
        #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
        #else
        return Bundle.main.bundleURL
        #endif
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL { Self.productsDirectory }
}

private extension SSGHTests {
    func process(withArguments arguments: [String],
                 pipe: Pipe? = nil,
                 handler: ((Process) -> Void)? = nil) -> Process {
        let binary = productsDirectory.appendingPathComponent("ssgh")
        print("binary: \(binary)")
        let process = Process()
        process.executableURL = binary
        process.arguments = arguments
        print("arguments: \(process.arguments ?? [])")
        handler?(process)
        print("environment: \(process.environment ?? [:])")
        if let pipe = pipe {
            process.standardOutput = pipe
        }
        return process
    }
}
