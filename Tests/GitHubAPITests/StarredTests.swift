import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.User

final class StarredTests: XCTestCase {
    let client = GitHubClient(token: "this-is-stub")

    override func tearDown() {
        clearStubs()
        super.tearDown()
    }

    func testIsStarred_true() throws {
        stubGetRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        XCTAssertTrue(try client.isStarred(userId: "417-72KI", repo: "SSGH").get())
    }

    func testIsStarred_false() throws {
        stubGetRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 404)

        XCTAssertFalse(try client.isStarred(userId: "417-72KI", repo: "SSGH").get())
    }

    func testStar_success() throws {
        stubPutRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        XCTAssertNoThrow(try client.star(userId: "417-72KI", repo: "SSGH").get())
    }

    func testUnstar_success() throws {
        stubDeleteRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        XCTAssertNoThrow(try client.unstar(userId: "417-72KI", repo: "SSGH").get())
    }

    // MARK: - async/await
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testIsStarred_true_async() async throws {
        stubGetRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        let result = try await client.isStarred(userId: "417-72KI", repo: "SSGH")
        XCTAssertTrue(result)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testIsStarred_false_async() async throws {
        stubGetRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 404)

        let result = try await client.isStarred(userId: "417-72KI", repo: "SSGH")
        XCTAssertFalse(result)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testStar_success_async() async throws {
        stubPutRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        await XCTAssertNoThrowAsync(try await client.star(userId: "417-72KI", repo: "SSGH"))
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testUnstar_success_async() async throws {
        stubDeleteRequest(path: "/user/starred/417-72KI/SSGH", statusCode: 204)

        await XCTAssertNoThrowAsync(try await client.unstar(userId: "417-72KI", repo: "SSGH"))
    }
}
