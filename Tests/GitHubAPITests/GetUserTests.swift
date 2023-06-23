import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class GetUserTests: XCTestCase {
    func testGetUser_success() throws {
        let stubSession = StubURLSession(path: "/users/417-72KI",
                                         method: .get,
                                         jsonFile: "get_user")
        XCTAssertFalse(stubSession.wasCalled)

        let expected = User(login: "417-72KI",
                            publicRepos: 80)

        let user = try GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getUser(by: "417-72KI")
            .get()
        XCTAssertEqual(user, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testGetUser_notExist() throws {
        let stubSession = StubURLSession(path: "/users/41772KI",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        let result = GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getUser(by: "41772KI")
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as? GitHubAPIError, .userNotFound("41772KI"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }

    // MARK: - async/await
    func testGetUser_success_async() async throws {
        let stubSession = StubURLSession(path: "/users/417-72KI",
                                         method: .get,
                                         jsonFile: "get_user")
        XCTAssertFalse(stubSession.wasCalled)

        let expected = User(login: "417-72KI",
                            publicRepos: 80)
        
        let user = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getUser(by: "417-72KI")
        XCTAssertEqual(user, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }
    
    func testGetUser_notExist_async() async throws {
        let stubSession = StubURLSession(path: "/users/41772KI",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertThrowsErrorAsync(
            try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .getUser(by: "41772KI")
        ) {
            XCTAssertEqual($0 as? GitHubAPIError, .userNotFound("41772KI"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }
}
