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
        dumpInfo("Fetching user data...")
        let user = try api.getUser(by: target).get()

        dumpInfo("Fetching repos...")
        let repos = try api.getRepos(for: user.login)
            .get()
            .map { ($0, try api.isStarred(userId: user.login, repo: $0.name).get()) }
            .filter { $0.1 }

        let starredRepoCount = repos.map { (repo, starred) -> Result<Void, GitHubClient.Error> in
            dumpInfo("Star to \(repo.fullName)")
            return api.unstar(userId: user.login, repo: repo.name)
        }.reduce(into: 0) { if case .success = $1 { $0 += 1 } }

        dumpInfo("\(starredRepoCount) repos starred!")
    }
}
