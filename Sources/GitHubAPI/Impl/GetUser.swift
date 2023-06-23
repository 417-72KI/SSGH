import Foundation
import OctoKit

extension GitHubClientImpl {
    @available(*, deprecated, message: "Use `async` function instead.")
    public func getUser(by userId: String) -> Result<User, GitHubAPIError> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var result: Result<OctoKit.User, Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.user(session, name: userId) {
            result = $0
            semaphore.signal()
        }
        semaphore.wait()
        return result.map(User.init)
            .mapError {
                if ($0 as NSError).code == 404 {
                    return .userNotFound(userId)
                }
                return .other($0)
            }
    }
}

extension GitHubClientImpl {
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
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
