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

    func getUser(by userId: String) async throws -> User
    func getRepos(for userId: String, page: UInt) async throws -> [Repo]
    func getReleases(for userId: String, repo: String) async throws -> [Release]
    func isStarred(userId: String, repo: String) async throws -> Bool
    func star(userId: String, repo: String) async throws
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
