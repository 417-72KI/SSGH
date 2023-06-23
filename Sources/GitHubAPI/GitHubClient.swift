import Foundation

public protocol GitHubClient {
    @available(*, deprecated, message: "Use `async` function instead.")
    func getUser(by userId: String) -> Result<User, GitHubAPIError>
    @available(*, deprecated, message: "Use `async` function instead.")
    func getRepos(for userId: String, page: UInt) -> Result<[Repo], GitHubAPIError>
    @available(*, deprecated, message: "Use `async` function instead.")
    func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubAPIError>
    @available(*, deprecated, message: "Use `async` function instead.")
    func isStarred(userId: String, repo: String) -> Result<Bool, GitHubAPIError>
    @available(*, deprecated, message: "Use `async` function instead.")
    func star(userId: String, repo: String) -> Result<Void, GitHubAPIError>
    @available(*, deprecated, message: "Use `async` function instead.")
    func unstar(userId: String, repo: String) -> Result<Void, GitHubAPIError>

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
}

public extension GitHubClient {
    @available(*, deprecated, message: "Use `async` function instead.")
    func getRepos(for userId: String) -> Result<[Repo], GitHubAPIError> {
        getRepos(for: userId, page: 1)
    }

    func getRepos(for userId: String) async throws -> [Repo] {
        try await getRepos(for: userId, page: 1)
    }
}
