import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class StarredTests: XCTestCase {
    func testIsStarred_true() throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .get,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        let isStarred = try GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .isStarred(userId: "417-72KI", repo: "SSGH")
            .get()
        XCTAssertTrue(isStarred)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testIsStarred_false() throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        let isStarred = try GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .isStarred(userId: "417-72KI", repo: "SSGH")
            .get()
        XCTAssertFalse(isStarred)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testStar_success() throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .put,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        XCTAssertNoThrow(
            try GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .star(userId: "417-72KI", repo: "SSGH")
                .get()
        )
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testUnstar_success() throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .delete,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        XCTAssertNoThrow(
            try GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .unstar(userId: "417-72KI", repo: "SSGH")
                .get()
        )
        XCTAssertTrue(stubSession.wasCalled)
    }

    // MARK: - async/await
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testIsStarred_true_async() async throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .get,
                                         statusCode: 204)
        XCTAssertFalse(stubSession.wasCalled)

        let result = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .isStarred(userId: "417-72KI", repo: "SSGH")
        XCTAssertTrue(result)
        XCTAssertTrue(stubSession.wasCalled)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testIsStarred_false_async() async throws {
        let stubSession = StubURLSession(path: "/user/starred/417-72KI/SSGH",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        let result = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .isStarred(userId: "417-72KI", repo: "SSGH")
        XCTAssertFalse(result)
        XCTAssertTrue(stubSession.wasCalled)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testStar_success_async() async throws {
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testUnstar_success_async() async throws {
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
