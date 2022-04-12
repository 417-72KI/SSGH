import Foundation
import OctoKit

extension GitHubClient {
    public func getRepos(for userId: String, page: UInt = 1) -> Result<[Repo], GitHubClient.Error> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var result: Result<[OctoKit.Repository], Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.repositories(session, owner: userId, page: "\(page)") {
            result = $0
            semaphore.signal()
        }
        semaphore.wait()
        return result.map { $0.map(Repo.init) }
            .mapError {
                if ($0 as NSError).code == 404 {
                    return .userNotFound(userId) }
                return .other($0)
            }
    }
}

#if compiler(>=5.5.2) && canImport(_Concurrency)
extension GitHubClient {
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getRepos(for userId: String, page: UInt = 1) async throws -> [Repo] {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.repositories(session, owner: userId, page: "\(page)") {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result.map(Repo.init))
                case let .failure(error):
                    if (error as NSError).code == 404 {
                        continuation.resume(throwing: Error.userNotFound(userId))
                    } else {
                        continuation.resume(throwing: Error.other(error))
                    }
                }
            }
        }
    }
}
#endif
