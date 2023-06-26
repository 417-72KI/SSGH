import Foundation
import OctoKit

extension GitHubClientImpl {
    public func getReleases(for userId: String, repo: String) async throws -> [Release] {
        do {
            let releases = try await octoKit.listReleases(session, owner: userId, repository: repo)
            return releases.map(Release.init)
        } catch let error as NSError where error.code == 404 {
            throw GitHubAPIError.repoNotFound("\(userId)/\(repo)")
        }
    }
}
