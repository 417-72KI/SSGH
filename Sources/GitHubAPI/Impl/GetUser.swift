import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getUser(by userId: String) async throws -> User {
        do {
            let user = try await octoKit.user(session, name: userId)
            return User(user)
        } catch {
            if case 404 = (error as NSError).code {
                throw GitHubAPIError.userNotFound(userId)
            } else {
                print(error)
                throw GitHubAPIError.other(error)
            }
        }
    }
}
