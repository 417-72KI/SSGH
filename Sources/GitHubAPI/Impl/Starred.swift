import Foundation
import OctoKit

extension GitHubClientImpl {
    public func isStarred(userId: String, repo: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.star(session, owner: userId, repository: repo) {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result)
                case let .failure(error):
                    continuation.resume(throwing: GitHubAPIError.other(error))
                }
            }
        }
    }

    public func star(userId: String, repo: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.putStar(session, owner: userId, repository: repo) {
                if let error = $0 {
                    continuation.resume(throwing: GitHubAPIError.other(error))
                } else {
                    continuation.resume()
                }
            }
        } as Void
    }

    public func unstar(userId: String, repo: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.deleteStar(session, owner: userId, repository: repo) {
                if let error = $0 {
                    continuation.resume(throwing: GitHubAPIError.other(error))
                } else {
                    continuation.resume()
                }
            }
        } as Void
    }
}
