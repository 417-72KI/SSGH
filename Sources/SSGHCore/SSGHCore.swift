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
            .filter { !$0.fork }
            .map { ($0, try api.isStarred(userId: user.login, repo: $0.name).get()) }
            .filter { !$0.1 }

        let starredRepoCount = repos.map { repo, _ -> Result<Void, GitHubClient.Error> in
            dumpInfo("Star to \(repo.fullName)")
            return api.star(userId: user.login, repo: repo.name)
        }
        .reduce(into: 0) {
            switch $1 {
            case .success:
                $0 += 1
            case let .failure(error):
                dumpError(error)
            }
        }

        dumpInfo("\(starredRepoCount) repos starred!")
    }
}
