import APIKit
import Foundation

extension GitHubClient {
    public func isStarred(userId: String, repo: String) -> Result<Bool, GitHubClient.Error> {
        sendSync(Starred.Get(owner: userId, repo: repo))
            .map { $0.response.statusCode == 204 }
            .flatMapError {
                if case let .responseError(re) = $0,
                    let responseError = re as? APIKit.ResponseError,
                    case let .unacceptableStatusCode(code) = responseError,
                    code == 404 { return .success(false) }
                return .failure(.other($0))
            }
    }
}

extension GitHubClient {
    enum Starred {
        struct Get: Request {
            typealias Response = EmptyEntity

            let owner: String
            let repo: String

            var method: HTTPMethod { .get }
            var path: String { "/user/starred/\(owner)/\(repo)" }
        }
    }
}
