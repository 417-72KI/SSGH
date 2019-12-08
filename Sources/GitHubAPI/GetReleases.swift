import APIKit
import Foundation

extension GitHubClient {
    public func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubClient.Error> {
        sendSync(Releases.Get(owner: userId, repo: repo))
            .mapError { .other($0) }
    }
}

extension GitHubClient {
    enum Releases {
        struct Get: Request {
            typealias Response = [Release]

            let owner: String
            let repo: String

            var method: HTTPMethod { .get }
            var path: String { "/repos/\(owner)/\(repo)/releases" }
        }
    }
}
