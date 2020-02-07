import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class GetUserTests: XCTestCase {
    let client = GitHubClient(token: "this-is-stub")

    override func tearDown() {
        clearStubs()
        super.tearDown()
    }

    func testGetUser_success() throws {
        stubGetRequest(path: "/users/417-72KI", responseData: [
            "id": 417,
            "login" : "417-72KI",
            "public_repos": 46
        ])

        let expected = User(login: "417-72KI",
                            publicRepos: 46)

        let user = try client.getUser(by: "417-72KI").get()
        XCTAssertEqual(user, expected)
    }

    func testGetUser_notExist() throws {
        stubGetRequest(path: "/users/41772KI", statusCode: 404)

        let result = client.getUser(by: "41772KI")
        XCTAssertThrowsError(try result.get()) {
            guard case .userNotFound("41772KI") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }
}
