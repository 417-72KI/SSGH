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
            let version = try XCTUnwrap(pipe.readString())
            XCTAssertEqual(Version(version), ApplicationInfo.version)
        }

        try context("no target") {
            let pipe = Pipe()
            let errorPipe = Pipe()
            let process = process(
                withArguments: [],
                pipe: pipe,
                errorPipe: errorPipe
            )
            XCTAssertNoThrow(try process.run())
            process.waitUntilExit()
            XCTAssertEqual(ExitCode(process.terminationStatus), .validationFailure)
            let error = try XCTUnwrap(errorPipe.readString()?.split(separator: "\n").first)
            XCTAssertEqual(error, "Error: Missing expected argument '<targets> ...'")
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
                 errorPipe: Pipe? = nil,
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
            process.standardError = pipe
        }
        if let errorPipe = errorPipe {
            process.standardError = errorPipe
        }
        return process
    }
}
