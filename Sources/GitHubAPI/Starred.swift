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

    public func star(userId: String, repo: String) -> Result<Void, GitHubClient.Error> {
        sendSync(Starred.Put(owner: userId, repo: repo))
            .flatMap {
                guard $0.response.statusCode == 204 else {
                    return .failure(SessionTaskError.responseError(ResponseError.unacceptableStatusCode($0.response.statusCode)))
                }
                return .success(())
            }
        .mapError { .other($0) }
    }

    public func unstar(userId: String, repo: String) -> Result<Void, GitHubClient.Error> {
        sendSync(Starred.Delete(owner: userId, repo: repo))
            .flatMap {
                guard $0.response.statusCode == 204 else {
                    return .failure(SessionTaskError.responseError(ResponseError.unacceptableStatusCode($0.response.statusCode)))
                }
                return .success(())
            }
        .mapError { .other($0) }
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

        struct Put: Request {
            typealias Response = EmptyEntity

            let owner: String
            let repo: String

            var method: HTTPMethod { .put }
            var path: String { "/user/starred/\(owner)/\(repo)" }
        }

        struct Delete: Request {
            typealias Response = EmptyEntity

            let owner: String
            let repo: String

            var method: HTTPMethod { .delete }
            var path: String { "/user/starred/\(owner)/\(repo)" }
        }
    }
}
