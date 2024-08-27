import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getRepos(for userId: String, page: UInt = 1) async throws -> [Repo] {
        do {
            let repos = try await octoKit.repositories(owner: userId, page: "\(page)")
            return repos.map(Repo.init)
        } catch {
            if case 404 = (error as NSError).code {
                throw GitHubAPIError.userNotFound(userId)
            } else {
                throw GitHubAPIError.other(error)
            }
        }
    }
}
