import Foundation
import OctoKit

extension GitHubClient {
    public func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubClient.Error> {
        var result: Result<[OctoKit.Release], Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.listReleases(owner: userId, repository: repo) {
            result = $0.result
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
