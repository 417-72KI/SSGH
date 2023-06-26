import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getUser(by userId: String) async throws -> User {
        do {
            let user = try await octoKit.user(session, name: userId)
            return User(user)
        } catch let error as NSError where error.code == 404 {
            throw GitHubAPIError.userNotFound(userId)
        }
    }
}
