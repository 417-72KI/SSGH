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
        stubGetRequest(path: "/users/417-72KI/repos", responseData: [
            [
               "id": 225647455,
               "name": "SSGH",
               "fullName": "417-72KI/SSGH",
               "fork": false,
               "private": false,
               "htmlUrl": "https://github.com/417-72KI",
               "description": "Deliver stars on your behalf"
            ]
        ])

        let expected: [Repo] = [
            Repo(id: 225647455,
                 name: "SSGH",
                 fullName: "417-72KI/SSGH",
                 fork: false,
                 private: false,
                 htmlUrl: "https://github.com/417-72KI",
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
}
