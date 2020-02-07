import APIKit
import Foundation

extension GitHubClient {
    public func getReleases(for userId: String, repo: String) -> Result<[Release], GitHubClient.Error> {
        sendSync(Releases.Get(owner: userId, repo: repo))
            .mapError {
                if case let .responseError(re) = $0,
                    let responseError = re as? APIKit.ResponseError,
                    case let .unacceptableStatusCode(code) = responseError,
                    code == 404 { return .repoNotFound("\(userId)/\(repo)") }
                return .other($0)
            }
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
