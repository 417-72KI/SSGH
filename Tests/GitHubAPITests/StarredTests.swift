import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class StarredTests: XCTestCase {
    func testIsStarred_true() async throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .get,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        let result = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .isStarred(userId: "417-72KI", repo: "SSGH")
        XCTAssertTrue(result)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testIsStarred_false() async throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        let result = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .isStarred(userId: "417-72KI", repo: "SSGH")
        XCTAssertFalse(result)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testStar_success() async throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .put,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertNoThrowAsync(
            try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .star(userId: "417-72KI", repo: "SSGH")
        )
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testUnstar_success() async throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .delete,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertNoThrowAsync(
            try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .unstar(userId: "417-72KI", repo: "SSGH")
        )
        XCTAssertTrue(stubSession.wasCalled)
    }
}
