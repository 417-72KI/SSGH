import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getReleases(for userId: String, repo: String) async throws -> [Release] {
        do {
            let releases = try await octoKit.listReleases(session, owner: userId, repository: repo)
            return releases.map(Release.init)
        } catch {
            if case 404 = (error as NSError).code {
                throw GitHubAPIError.repoNotFound("\(userId)/\(repo)")
            } else {
                throw GitHubAPIError.other(error)
            }
        }
    }
}
