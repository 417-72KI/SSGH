import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class GetUserTests: XCTestCase {
    func testGetUser_success() throws {
        let stubSession = StubURLSession(testRun: testRun,
                                         path: "/users/417-72KI",
                                         method: .get,
                                         jsonFile: "get_user")
        XCTAssertFalse(stubSession.wasCalled)

        let expected = User(login: "417-72KI",
                            publicRepos: 80)

        let user = try GitHubClient(token: "this-is-stub", session: stubSession)
            .getUser(by: "417-72KI")
            .get()
        XCTAssertEqual(user, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testGetUser_notExist() throws {
        let stubSession = StubURLSession(testRun: testRun,
                                         path: "/users/41772KI",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        let result = GitHubClient(token: "this-is-stub", session: stubSession)
            .getUser(by: "41772KI")
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as? GitHubClient.Error, .userNotFound("41772KI"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }

    // MARK: - async/await
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetUser_success_async() async throws {
        let stubSession = StubURLSession(testRun: testRun,
                                         path: "/users/417-72KI",
                                         method: .get,
                                         jsonFile: "get_user")
        XCTAssertFalse(stubSession.wasCalled)

        let expected = User(login: "417-72KI",
                            publicRepos: 80)
        
        let user = try await GitHubClient(token: "this-is-stub", session: stubSession)
            .getUser(by: "417-72KI")
        XCTAssertEqual(user, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetUser_notExist_async() async throws {
        let stubSession = StubURLSession(testRun: testRun,
                                         path: "/users/41772KI",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertThrowsErrorAsync(
            try await GitHubClient(token: "this-is-stub", session: stubSession)
                .getUser(by: "41772KI")
        ) {
            XCTAssertEqual($0 as? GitHubClient.Error, .userNotFound("41772KI"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }
    #endif
}
