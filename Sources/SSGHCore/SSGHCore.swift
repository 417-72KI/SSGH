import Foundation
import GitHubAPI

public struct SSGHCore {
    let target: String
    let gitHubToken: String

    public init(target: String, gitHubToken: String) {
        self.target = target
        self.gitHubToken = gitHubToken
    }
}

public extension SSGHCore {
    func execute() throws {
        let api = GitHubClient(token: gitHubToken)
        _ = try api.getUser(by: target).get()

        let repos = try api.getRepos(for: target).get()
        try repos.map { ($0, try api.isStarred(userId: target, repo: $0.name).get()) }
            .forEach { print($0) }
    }
}
