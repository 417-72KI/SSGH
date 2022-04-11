import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.Repo

final class GetReposTests: XCTestCase {
    let client = GitHubClient(token: "this-is-stub")

    override func tearDown() {
        clearStubs()
        super.tearDown()
    }

    func testGetRepos_success() throws {
        stubGetRequest(path: "/users/417-72KI/repos", responseFileName: "get_repos.json")

        let expected: [Repo] = [
            Repo(id: 225647455,
                 name: "SSGH",
                 fullName: "417-72KI/SSGH",
                 fork: false,
                 private: false,
                 htmlUrl: "https://github.com/417-72KI/SSGH",
                 description: "Deliver stars on your behalf")
        ]
        let repos = try client.getRepos(for: "417-72KI").get()
        XCTAssertEqual(repos, expected)
    }

    func testGetRepos_userNotExist() throws {
        stubGetRequest(path: "/users/41772KI/repos", statusCode: 404)

        let result = client.getRepos(for: "41772KI")
        XCTAssertThrowsError(try result.get()) {
            guard case .userNotFound("41772KI") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }

    // MARK: - async/await
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetRepos_success_async() async throws {
        stubGetRequest(path: "/users/417-72KI/repos", responseFileName: "get_repos.json")

        let expected: [Repo] = [
            Repo(id: 225647455,
                 name: "SSGH",
                 fullName: "417-72KI/SSGH",
                 fork: false,
                 private: false,
                 htmlUrl: "https://github.com/417-72KI/SSGH",
                 description: "Deliver stars on your behalf")
        ]
        let repos = try await client.getRepos(for: "417-72KI")
        XCTAssertEqual(repos, expected)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetRepos_userNotExist_async() async throws {
        stubGetRequest(path: "/users/41772KI/repos", statusCode: 404)

        await XCTAssertThrowsErrorAsync(try await client.getRepos(for: "41772KI")) {
            guard case .userNotFound("41772KI") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }
    #endif
}
