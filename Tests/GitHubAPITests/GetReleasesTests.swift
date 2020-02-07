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
        stubGetRequest(path: "/repos/417-72KI/SSGH/releases", responseData: [
            [
                "name": "1.0.0",
                "url": "https://api.github.com/repos/417-72KI/SSGH/releases/22078686",
                "tag_name":"1.0.0",
                "prerelease":false,
                "draft":false
            ]
        ])
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
        errorStubGetRequest(path: "/repos/41772KI/SSGH/releases", statusCode: 404)

        let result = client.getReleases(for: "41772KI", repo: "SSGH")
        XCTAssertThrowsError(try result.get()) {
            guard case .repoNotFound("41772KI/SSGH") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }

    func testGetReleases_repoNotExist() throws {
        errorStubGetRequest(path: "/repos/417-72KI/SGH/releases", statusCode: 404)

        let result = client.getReleases(for: "417-72KI", repo: "SGH")
        XCTAssertThrowsError(try result.get()) {
            guard case .repoNotFound("417-72KI/SGH") = ($0 as? GitHubClient.Error) else {
                XCTFail("Unexpected error: \($0)")
                return
            }
        }
    }
}
