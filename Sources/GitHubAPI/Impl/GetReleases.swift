import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getReleases(for userId: String, repo: String) async throws -> [Release] {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.listReleases(session, owner: userId, repository: repo) {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result.map(Release.init))
                case let .failure(error):
                    if (error as NSError).code == 404 {
                        continuation.resume(throwing: GitHubAPIError.repoNotFound("\(userId)/\(repo)"))
                    } else {
                        continuation.resume(throwing: GitHubAPIError.other(error))
                    }
                }
            }
        }
    }
}
