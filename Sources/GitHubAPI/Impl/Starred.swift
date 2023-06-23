import Foundation
import OctoKit

extension GitHubClientImpl {
    @available(*, deprecated, message: "Use `async` function instead.")
    public func isStarred(userId: String, repo: String) -> Result<Bool, GitHubAPIError> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var result: Result<Bool, Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.star(session, owner: userId, repository: repo) {
            result = $0
            semaphore.signal()
        }
        semaphore.wait()
        return result
            .mapError(GitHubAPIError.other)
    }

    @available(*, deprecated, message: "Use `async` function instead.")
    public func star(userId: String, repo: String) -> Result<Void, GitHubAPIError> {
        var error: Swift.Error?
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.putStar(session, owner: userId, repository: repo) {
            error = $0
            semaphore.signal()
        }
        semaphore.wait()
        if let error = error {
            return .failure(.other(error))
        }
        return .success(())
    }

    @available(*, deprecated, message: "Use `async` function instead.")
    public func unstar(userId: String, repo: String) -> Result<Void, GitHubAPIError> {
        var error: Swift.Error?
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.deleteStar(session, owner: userId, repository: repo) {
            error = $0
            semaphore.signal()
        }
        semaphore.wait()
        if let error = error {
            return .failure(.other(error))
        }
        return .success(())
    }
}

extension GitHubClientImpl {
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
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

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
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
