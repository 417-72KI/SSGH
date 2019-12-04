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

        func fetchAllRepos() throws -> [Repo] {
            var page: UInt = 1
            var repos: [Repo] = []
            while true {
                let reposPerPage = try api.getRepos(for: user.login, page: page).get()
                if reposPerPage.isEmpty { break }
                repos += reposPerPage
                page += 1
            }
            return repos
        }

        let repos = try fetchAllRepos()
        let starrableRepos = try repos.filter { !$0.fork }
            .filter { !(try api.isStarred(userId: user.login, repo: $0.name).get()) }
        dumpDebug("\(starrableRepos.count) repos detected")

        let starredRepoCount = starrableRepos.map { repo -> Result<Void, GitHubClient.Error> in
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
