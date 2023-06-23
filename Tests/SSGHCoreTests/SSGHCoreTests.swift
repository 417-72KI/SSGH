import Foundation
import XCTest

@testable import GitHubAPI
@testable import SSGHCore

final class SSGHCoreTests: XCTestCase {
    private var client: StubClient!

    override func setUp() {
        client = StubClient()
    }

    func testExecute() async throws {
        let core = SSGHCore(gitHubClient: client,
                            dryRunMode: false)
        XCTAssertEqual(client.starredRepos, [])
        try await core.execute(mode: .specifiedTargets(["417-72KI", "octocat"]))

        XCTAssertEqual(client.starredRepos, Set(client.repos.values.flatMap { $0 }))
    }

    func testExecuteWithDryRunMode() async throws {
        let core = SSGHCore(gitHubClient: client,
                            dryRunMode: true)
        XCTAssertEqual(client.starredRepos, [])
        try await core.execute(mode: .specifiedTargets(["417-72KI", "octocat"]))

        XCTAssertEqual(client.starredRepos, [])
    }
}

final class StubClient: GitHubClient {
    private(set) var users = [
        User(login: "octocat", publicRepos: 60),
        User(login: "417-72KI", publicRepos: 80)
    ]

    private(set) var repos = [
        "octocat": [
            Repo(
                id: 1,
                name: "Hello-World",
                fullName: "octocat/Hello-World",
                fork: false,
                private: false,
                htmlUrl: "https://github.com/octocat/Hello-World",
                description: "My first repository on GitHub!"
            )
        ],
        "417-72KI": [
            Repo(
                id: 2,
                name: "SSGH",
                fullName: "417-72KI/SSGH",
                fork: false,
                private: false,
                htmlUrl: "https://github.com/417-72KI/SSGH",
                description: "Deliver stars on your behalf"
            ),
            Repo(
                id: 3,
                name: "BuildConfig.swift",
                fullName: "417-72KI/BuildConfig.swift",
                fork: false,
                private: false,
                htmlUrl: "https://github.com/417-72KI/BuildConfig.swift",
                description: "Android-like auto-generate configuration files for macOS/iOS"
            ),
            Repo(
                id: 4,
                name: "MultipartFormDataParser",
                fullName: "417-72KI/MultipartFormDataParser",
                fork: false,
                private: false,
                htmlUrl: "https://github.com/417-72KI/MultipartFormDataParser",
                description: "Testing tool for `multipart/form-data`"
            )
        ]
    ]
    private(set) var starredRepos: Set<Repo> = []
}

extension StubClient {
    func getUser(by userId: String) -> Result<User, GitHubAPIError> {
        guard let user = users.first(where: { $0.login == userId }) else { return .failure(.userNotFound(userId)) }
        return .success(user)
    }

    func getRepos(for userId: String, page: UInt) -> Result<[Repo], GitHubAPIError> {
        .success(page == 1 ? repos[userId] ?? [] : [])
    }

    func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubAPIError> {
        .success([])
    }

    func isStarred(userId: String, repo: String) -> Result<Bool, GitHubAPIError> {
        .success(
            starredRepos
                .map(\.fullName)
                .contains("\(userId)/\(repo)")
        )
    }

    func star(userId: String, repo: String) -> Result<Void, GitHubAPIError> {
        guard let repo = repos[userId]?.first(where: { $0.fullName == "\(userId)/\(repo)" }) else { return .failure(.repoNotFound("\(userId)/\(repo)")) }
        starredRepos.insert(repo)
        return .success(())
    }

    func unstar(userId: String, repo: String) -> Result<Void, GitHubAPIError> {
        guard let repo = starredRepos.first(where: { $0.fullName == "\(userId)/\(repo)" }) else { return .failure(.repoNotFound("\(userId)/\(repo)")) }
        starredRepos.remove(repo)
        return .success(())
    }
}

extension StubClient {
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getUser(by userId: String) async throws -> User {
        switch getUser(by: userId) as Result {
        case let .success(result): return result
        case let .failure(error): throw error
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getRepos(for userId: String, page: UInt) async throws -> [Repo] {
        switch getRepos(for: userId, page: page) as Result {
        case let .success(result): return result
        case let .failure(error): throw error
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getReleases(for userId: String, repo: String) async throws -> [Release] {
        switch getReleases(for: userId, repo: repo) as Result {
        case let .success(result): return result
        case let .failure(error): throw error
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func isStarred(userId: String, repo: String) async throws -> Bool {
        switch isStarred(userId: userId, repo: repo) as Result {
        case let .success(result): return result
        case let .failure(error): throw error
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func star(userId: String, repo: String) async throws {
        switch star(userId: userId, repo: repo) as Result {
        case let .success(result): return result
        case let .failure(error): throw error
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func unstar(userId: String, repo: String) async throws {
        switch unstar(userId: userId, repo: repo) as Result {
        case let .success(result): return result
        case let .failure(error): throw error
        }
    }
}
