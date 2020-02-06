import Foundation
import OctoKit

extension GitHubClient {
    public func getUser(by userId: String) -> Result<User, Error> {
        var result: Result<OctoKit.User, Swift.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        octoKit.user(name: userId) {
            result = $0.result
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
