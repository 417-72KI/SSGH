import Foundation
import OctoKit
import RequestKit

public protocol GitHubClient {
    func getUser(by userId: String) -> Result<User, GitHubAPIError>
    func getRepos(for userId: String, page: UInt) -> Result<[Repo], GitHubAPIError>
    func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubAPIError>
    func isStarred(userId: String, repo: String) -> Result<Bool, GitHubAPIError>
    func star(userId: String, repo: String) -> Result<Void, GitHubAPIError>
    func unstar(userId: String, repo: String) -> Result<Void, GitHubAPIError>

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getUser(by userId: String) async throws -> User
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getRepos(for userId: String, page: UInt) async throws -> [Repo]
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func getReleases(for userId: String, repo: String) async throws -> [Release]
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func isStarred(userId: String, repo: String) async throws -> Bool
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func star(userId: String, repo: String) async throws
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func unstar(userId: String, repo: String) async throws
    #endif
}

public extension GitHubClient {
    func getRepos(for userId: String) -> Result<[Repo], GitHubAPIError> {
        getRepos(for: userId, page: 1)
    }

    #if compiler(>=5.5.2) && canImport(_Concurrency)
    func getRepos(for userId: String) async throws -> [Repo] {
        try await getRepos(for: userId, page: 1)
    }
    #endif
}

public func defaultGitHubClient(token: String, session: RequestKitURLSession = URLSession.shared) -> GitHubClient {
    GitHubClientImpl(token: token, session: session)
}

class GitHubClientImpl: GitHubClient {
    let domain = "https://github.com"

    let octoKit: Octokit
    let session: RequestKitURLSession

    init(token: String, session: RequestKitURLSession) {
        octoKit = .init(.init(token))
        self.session = session
    }
}
