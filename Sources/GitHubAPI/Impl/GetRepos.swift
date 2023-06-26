import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getRepos(for userId: String, page: UInt = 1) async throws -> [Repo] {
        do {
            let repos = try await octoKit.repositories(session, owner: userId, page: "\(page)")
            return repos.map(Repo.init)
        } catch let error as NSError where error.code == 404 {
            throw GitHubAPIError.userNotFound(userId)
        }
    }
}
