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

    func testGetRepos() throws {
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
        let result = client.getRepos(for: "417-72KI")
        switch result {
        case let .success(repos):
            XCTAssertEqual(repos, expected)
        case let .failure(error):
            XCTFail(error.description)
        }
    }
}
