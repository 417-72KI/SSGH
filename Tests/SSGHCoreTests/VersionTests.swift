import XCTest

@testable import SSGHCore

class VersionTests: XCTestCase {

    func testStringLiteral() {
        XCTAssertEqual("1.4", Version(1, 4, 0))
        XCTAssertEqual("v2.8.9", Version(2, 8, 9))
        XCTAssertEqual("2.8.2-alpha", Version(2, 8, 2, preRelease: "alpha"))
        XCTAssertEqual("2.8.2-alpha+build234", Version(2, 8, 2, preRelease: "alpha", buildMetadata: "build234"))
        XCTAssertEqual("2.8.2+build234", Version(2, 8, 2, buildMetadata: "build234"))
        XCTAssertEqual("2.8.2-alpha.2.1.0", Version(2, 8, 2, preRelease: "alpha.2.1.0"))
    }

    func testDescription() {
        XCTAssertEqual(Version(1, 4, 0).description, "1.4.0")
        XCTAssertEqual(Version(2, 8, 9).description, "2.8.9")
        XCTAssertEqual(Version(2, 8, 2, preRelease: "alpha").description, "2.8.2-alpha")
        XCTAssertEqual(Version(2, 8, 2, preRelease: "alpha", buildMetadata: "build234").description, "2.8.2-alpha+build234")
        XCTAssertEqual(Version(2, 8, 2, buildMetadata: "build234").description, "2.8.2+build234")
        XCTAssertEqual(Version(2, 8, 2, preRelease: "alpha.2.1.0").description, "2.8.2-alpha.2.1.0")
    }
}
