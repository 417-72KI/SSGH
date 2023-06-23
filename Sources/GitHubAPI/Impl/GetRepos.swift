import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getRepos(for userId: String, page: UInt = 1) async throws -> [Repo] {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.repositories(session, owner: userId, page: "\(page)") {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result.map(Repo.init))
                case let .failure(error):
                    if (error as NSError).code == 404 {
                        continuation.resume(throwing: GitHubAPIError.userNotFound(userId))
                    } else {
                        continuation.resume(throwing: GitHubAPIError.other(error))
                    }
                }
            }
        }
    }
}
