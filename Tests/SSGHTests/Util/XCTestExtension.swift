import Foundation
import XCTest

extension XCTestCase {
    func context(_ name: String, block: () throws -> Void) rethrows {
        #if os(macOS)
        if let _ = ProcessInfo().environment["XCTestConfigurationFilePath"] {
            // FIXME: Run test with `swift test`, it fails with message: `XCTContext.runActivity(named:block:) failed because activities are disallowed in the current configuration.`
            return try XCTContext.runActivity(named: name) { _ in try block() }
        }
        #endif
        return try block()
    }
}
