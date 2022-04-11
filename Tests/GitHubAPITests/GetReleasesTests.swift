import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.Release

final class GetReleasesTests: XCTestCase {
    let client = GitHubClient(token: "this-is-stub")

    override func tearDown() {
        clearStubs()
        super.tearDown()
    }

    func testGetReleases_success() throws {
        stubGetRequest(path: "/repos/417-72KI/SSGH/releases", responseFileName: "get_releases.json")
        let expected: [Release] = [Release(url: URL(string: "https://api.github.com/repos/417-72KI/SSGH/releases/22078686")!,
                                           name: "1.0.0",
                                           tagName: "1.0.0",
                                           prerelease: false,
                                           draft: false)

        ]
        let releases = try client.getReleases(for: "417-72KI", repo: "SSGH").get()
        XCTAssertEqual(releases, expected)
    }

    func testGetReleases_userNotExist() throws {
        stubGetRequest(path: "/repos/41772KI/SSGH/releases", statusCode: 404)

        let result = client.getReleases(for: "41772KI", repo: "SSGH")
        XCTAssertThrowsError(try result.get()) {
            guard case .repoNotFound("41772KI/SSGH") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }

    func testGetReleases_repoNotExist() throws {
        stubGetRequest(path: "/repos/417-72KI/SGH/releases", statusCode: 404)

        let result = client.getReleases(for: "417-72KI", repo: "SGH")
        XCTAssertThrowsError(try result.get()) {
            guard case .repoNotFound("417-72KI/SGH") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }

    // MARK: - async/await
    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetReleases_success_async() async throws {        
        stubGetRequest(path: "/repos/417-72KI/SSGH/releases", responseFileName: "get_releases.json")
        let expected: [Release] = [Release(url: URL(string: "https://api.github.com/repos/417-72KI/SSGH/releases/22078686")!,
                                           name: "1.0.0",
                                           tagName: "1.0.0",
                                           prerelease: false,
                                           draft: false)

        ]
        let releases = try await client.getReleases(for: "417-72KI", repo: "SSGH")
        XCTAssertEqual(releases, expected)
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetReleases_userNotExist_async() async throws {
        stubGetRequest(path: "/repos/41772KI/SSGH/releases", statusCode: 404)

        await XCTAssertThrowsErrorAsync(try await client.getReleases(for: "41772KI", repo: "SSGH")) {
            guard case .repoNotFound("41772KI/SSGH") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func testGetReleases_repoNotExist_async() async throws {
        stubGetRequest(path: "/repos/417-72KI/SSGH/releases", statusCode: 404)

        await XCTAssertThrowsErrorAsync(try await client.getReleases(for: "417-72KI", repo: "SSGH")) {
            guard case .repoNotFound("417-72KI/SSGH") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }
    #endif
}
