import APIKit
import Foundation

extension GitHubClient {
    public func getRepos(for userId: String) -> Result<[Repo], GitHubClient.Error> {
        sendSync(Repos.Get(owner: userId))
            .mapError { .other($0) }
    }
}

extension GitHubClient {
    enum Repos {
        struct Get: Request {
            typealias Response = [Repo]

            let owner: String

            var method: HTTPMethod { .get }
            var path: String { "/users/\(owner)/repos" }
        }
    }
}
