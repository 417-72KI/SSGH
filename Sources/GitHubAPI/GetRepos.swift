import Foundation
import OctoKit

extension GitHubClient {
    public func getRepos(for userId: String, page: UInt = 1) -> Result<[Repo], GitHubClient.Error> {
        var result: Result<[OctoKit.Repository], Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.repositories(owner: userId, page: "\(page)") {
            result = $0.result
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
