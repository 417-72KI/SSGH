import Foundation
import OctoKit

extension GitHubClient {
    public func isStarred(userId: String, repo: String) -> Result<Bool, GitHubClient.Error> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var result: Result<Bool, Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.star(owner: userId, repository: repo) {
            result = $0
            semaphore.signal()
        }
        semaphore.wait()
        return result
            .mapError(GitHubClient.Error.other)
    }

    public func star(userId: String, repo: String) -> Result<Void, GitHubClient.Error> {
        var error: Swift.Error?
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.putStar(owner: userId, repository: repo) {
            error = $0
            semaphore.signal()
        }
        semaphore.wait()
        if let error = error {
            return .failure(.other(error))
        }
        return .success(())
    }

    public func unstar(userId: String, repo: String) -> Result<Void, GitHubClient.Error> {
        var error: Swift.Error?
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.deleteStar(owner: userId, repository: repo) {
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

extension GitHubClient {
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func isStarred(userId: String, repo: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.star(owner: userId, repository: repo) {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result)
                case let .failure(error):
                    continuation.resume(throwing: Error.other(error))
                }
            }
        }
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func star(userId: String, repo: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.putStar(owner: userId, repository: repo) {
                if let error = $0 {
                    continuation.resume(throwing: Error.other(error))
                } else {
                    continuation.resume()
                }
            }
        } as Void
    }

    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func unstar(userId: String, repo: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.deleteStar(owner: userId, repository: repo) {
                if let error = $0 {
                    continuation.resume(throwing: Error.other(error))
                } else {
                    continuation.resume()
                }
            }
        } as Void
    }
}
