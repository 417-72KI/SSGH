import Foundation
import GitHubAPI
import XCTest

@testable import struct GitHubAPI.Release

final class GetReleasesTests: XCTestCase {
    func testGetReleases_success() async throws {
        let stubSession = StubURLSession(path: "/repos/417-72KI/SSGH/releases",
                                         method: .get,
                                         jsonFile: "get_releases")
        XCTAssertFalse(stubSession.wasCalled)

        let expected: [Release] = [Release(url: URL(string: "https://api.github.com/repos/417-72KI/SSGH/releases/22078686")!,
                                           name: "1.0.0",
                                           tagName: "1.0.0",
                                           prerelease: false,
                                           draft: false)

        ]
        let releases = try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
            .getReleases(for: "417-72KI", repo: "SSGH")
        XCTAssertEqual(releases, expected)
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testGetReleases_userNotExist() async throws {
        let stubSession = StubURLSession(path: "/repos/41772KI/SSGH/releases",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertThrowsErrorAsync(
            try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .getReleases(for: "41772KI", repo: "SSGH")
        ) {
            XCTAssertEqual($0 as? GitHubAPIError, .repoNotFound("41772KI/SSGH"))
        }
        XCTAssertTrue(stubSession.wasCalled)
    }

    func testGetReleases_repoNotExist() async throws {
        let stubSession = StubURLSession(path: "/repos/417-72KI/SGH/releases",
                                         method: .get,
                                         statusCode: 404)
        XCTAssertFalse(stubSession.wasCalled)

        await XCTAssertThrowsErrorAsync(
            try await GitHubClientImpl(token: "this-is-stub", session: stubSession)
                .getReleases(for: "417-72KI", repo: "SGH")
        ) {
            XCTAssertEqual($0 as? GitHubAPIError, .repoNotFound("417-72KI/SGH"))
        }
    }
}
