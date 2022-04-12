import Foundation
import OctoKit

extension GitHubClient {
    public func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubClient.Error> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var result: Result<[OctoKit.Release], Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.listReleases(session, owner: userId, repository: repo) {
            result = $0
            semaphore.signal()
        }
        semaphore.wait()
        return result.map { $0.map(Release.init) }
            .mapError {
                if ($0 as NSError).code == 404 { return .repoNotFound("\(userId)/\(repo)") }
                return .other($0)
            }
    }
}

#if compiler(>=5.5.2) && canImport(_Concurrency)
extension GitHubClient {
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    public func getReleases(for userId: String, repo: String) async throws -> [Release] {
        try await withCheckedThrowingContinuation { continuation in
            octoKit.listReleases(session, owner: userId, repository: repo) {
                switch $0 {
                case let .success(result):
                    continuation.resume(returning: result.map(Release.init))
                case let .failure(error):
                    if (error as NSError).code == 404 {
                        continuation.resume(throwing: Error.repoNotFound("\(userId)/\(repo)"))
                    } else {
                        continuation.resume(throwing: Error.other(error))
                    }
                }
            }
        }
    }
}
#endif
