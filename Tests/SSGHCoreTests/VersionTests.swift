import XCTest
import ParameterizedTestUtil

@testable import SSGHCore

class VersionTests: XCTestCase {
    override static func setUp() {
        super.setUp()
        ParameterizedTestUtil.needsDump = true
    }

    func testStringLiteral() {
        runAll(
            expect("1.4", equals: Version(1, 4, 0)),
            expect("v2.8.9", equals: Version(2, 8, 9)),
            expect("2.8.2-alpha", equals: Version(2, 8, 2, preRelease: "alpha")),
            expect("2.8.2-alpha+build234", equals: Version(2, 8, 2, preRelease: "alpha", buildMetadata: "build234")),
            expect("2.8.2+build234", equals: Version(2, 8, 2, buildMetadata: "build234")),
            expect("2.8.2-alpha.2.1.0", equals: Version(2, 8, 2, preRelease: "alpha.2.1.0"))
        )
    }

    func testDescription() {
        runAll(
            expect(Version(1, 4, 0).description, equals: "1.4.0"),
            expect(Version(2, 8, 9).description, equals: "2.8.9"),
            expect(Version(2, 8, 2, preRelease: "alpha").description, equals: "2.8.2-alpha"),
            expect(Version(2, 8, 2, preRelease: "alpha", buildMetadata: "build234").description, equals: "2.8.2-alpha+build234"),
            expect(Version(2, 8, 2, buildMetadata: "build234").description, equals: "2.8.2+build234"),
            expect(Version(2, 8, 2, preRelease: "alpha.2.1.0").description, equals: "2.8.2-alpha.2.1.0")
        )
    }

    func testCompare() {
        runAll(
            expect(Version(1, 4, 0), lessThan: "1.4.1"),
            expect(Version(1, 5, 0), moreThan: "1.4.1"),
            expect("2.0.0", moreThan: Version(1, 4, 1)),
            expect(Version(2, 0, 0, preRelease: "alpha"), lessThan: "2.0.0")
        )
    }
}
