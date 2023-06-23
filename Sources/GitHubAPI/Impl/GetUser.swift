import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getUser(by userId: String) async throws -> User {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.user(session, name: userId) {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: User(result))
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
