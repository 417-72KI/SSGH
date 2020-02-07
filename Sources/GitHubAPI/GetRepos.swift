import APIKit
import Foundation

extension GitHubClient {
    public func getRepos(for userId: String, page: UInt = 1) -> Result<[Repo], GitHubClient.Error> {
        sendSync(Repos.Get(owner: userId, page: page))
            .mapError {
                if case let .responseError(re) = $0,
                    let responseError = re as? APIKit.ResponseError,
                    case let .unacceptableStatusCode(code) = responseError,
                    code == 404 { return .userNotFound(userId) }
                return .other($0)
            }
    }
}

extension GitHubClient {
    enum Repos {
        struct Get: Request {
            typealias Response = [Repo]

            let owner: String
            let page: UInt

            var method: HTTPMethod { .get }
            var path: String { "/users/\(owner)/repos" }
            // swiftlint:disable:next discouraged_optional_collection
            var queryParameters: [String: Any]? { ["page": page] }
        }
    }
}
