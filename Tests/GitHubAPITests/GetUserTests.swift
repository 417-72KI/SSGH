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
        stubGetRequest(path: "/users/417-72KI", responseFileName: "get_user.json")

        let expected = User(login: "417-72KI",
                            publicRepos: 80)

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

    // MARK: - async/await
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetUser_success_async() async throws {
        stubGetRequest(path: "/users/417-72KI", responseFileName: "get_user.json")
        
        let expected = User(login: "417-72KI",
                            publicRepos: 80)
        
        let user = try await client.getUser(by: "417-72KI")
        XCTAssertEqual(user, expected)
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetUser_notExist_async() async throws {
        stubGetRequest(path: "/users/41772KI", statusCode: 404)
        
        await XCTAssertThrowsErrorAsync(try await client.getUser(by: "41772KI")) {
            guard case .userNotFound("41772KI") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }
}
