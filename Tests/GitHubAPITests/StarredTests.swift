import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class StarredTests: XCTestCase {
    let client = GitHubClient(token: "this-is-stub")

    override func tearDown() {
        clearStubs()
        super.tearDown()
    }

    func testIsStarred_true() throws {
        errorStubGetRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        XCTAssertTrue(try client.isStarred(userId: "417-72KI", repo: "SSGH").get())
    }

    func testIsStarred_false() throws {
        errorStubGetRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 404)

        XCTAssertFalse(try client.isStarred(userId: "417-72KI", repo: "SSGH").get())
    }

    func testStar_success() throws {
        stubPutRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        XCTAssertNoThrow(try client.star(userId: "417-72KI", repo: "SSGH").get())
    }

    func testUnstar_success() throws {
        stubDeleteRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        XCTAssertNoThrow(try client.unstar(userId: "417-72KI", repo: "SSGH").get())
    }
}
