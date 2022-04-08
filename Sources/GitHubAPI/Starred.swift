import Foundation
import OctoKit

extension GitHubClient {
    public func isStarred(userId: String, repo: String) -> Result<Bool, GitHubClient.Error> {
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
