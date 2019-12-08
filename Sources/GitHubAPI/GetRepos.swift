import APIKit
import Foundation

extension GitHubClient {
    public func getRepos(for userId: String, page: UInt = 1) -> Result<[Repo], GitHubClient.Error> {
        sendSync(Repos.Get(owner: userId, page: page))
            .mapError { .other($0) }
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
