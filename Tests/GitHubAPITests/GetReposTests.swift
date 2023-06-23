import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.Repo

final class GetReposTests: XCTestCase {
    func testGetRepos_success() throws {
        let stubSession = StubURLSession(path: "/users/417-72KI/repos",
                                         method: .get,
                                         jsonFile: "get_repos")
        XCTAssertFalse(stubSession.wasCalled)

        let expected: [Repo] = [
            Repo(id: 225647455,
                 name: "SSGH",
                 fullName: "417-72KI/SSGH",
                 fork: false,
                 private: false,
                 htmlUrl: "https://github.com/417-72KI/SSGH",
                 description: "Deliver stars on your behalf")
        ]
        let repos = try GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getRepos(for: "417-72KI")
            .get()
        XCTAssertEqual(repos, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testGetRepos_userNotExist() throws {
        let stubSession = StubURLSession(path: "/users/41772KI/repos",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        let result = GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getRepos(for: "41772KI")
        XCTAssertThrowsError(try result.get()) {
            XCTAssertEqual($0 as? GitHubAPIError, .userNotFound("41772KI"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }

    // MARK: - async/await
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetRepos_success_async() async throws {
        let stubSession = StubURLSession(path: "/users/417-72KI/repos",
                                         method: .get,
                                         jsonFile: "get_repos")
        XCTAssertFalse(stubSession.wasCalled)

        let expected: [Repo] = [
            Repo(id: 225647455,
                 name: "SSGH",
                 fullName: "417-72KI/SSGH",
                 fork: false,
                 private: false,
                 htmlUrl: "https://github.com/417-72KI/SSGH",
                 description: "Deliver stars on your behalf")
        ]
        let repos = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getRepos(for: "417-72KI")
        XCTAssertEqual(repos, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetRepos_userNotExist_async() async throws {
        let stubSession = StubURLSession(path: "/users/41772KI/repos",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertThrowsErrorAsync(
            try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .getRepos(for: "41772KI")
        ) {
            XCTAssertEqual($0 as? GitHubAPIError, .userNotFound("41772KI"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }
}
