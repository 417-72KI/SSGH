import Foundation

public protocol GitHubClient {
    func getUser(by userId: String) async throws -> User
    func getRepos(for userId: String, page: UInt) async throws -> [Repo]
    func getReleases(for userId: String, repo: String) async throws -> [Release]
    func isStarred(userId: String, repo: String) async throws -> Bool
    func star(userId: String, repo: String) async throws
    func unstar(userId: String, repo: String) async throws
}

public extension GitHubClient {
    func getRepos(for userId: String) async throws -> [Repo] {
        try await getRepos(for: userId, page: 1)
    }
}
