import Foundation
import GitHubAPI

public struct SSGHCore {
    private let gitHubClient: GitHubClient

    public init(gitHubToken: String) {
        gitHubClient = .init(token: gitHubToken)
    }
}

public extension SSGHCore {
    func execute(mode: Mode) throws {
        defer { confirmUpdate() }
        switch mode {
        case let .specifiedTargets(target):
            dumpInfo("Fetching users...")
            try target.map { try gitHubClient.getUser(by: $0).get() }
                .forEach(star(to:))
        }
    }
}

private extension SSGHCore {
    func star(to user: User) throws {
        dumpInfo("Fetching repos for \(user)...")
        let repos = try fetchAllRepos(of: user)
        let starrableRepos = try repos.filter { !$0.fork }
            .filter { !(try gitHubClient.isStarred(userId: user.login, repo: $0.name).get()) }
        dumpDebug("\(starrableRepos.count) repos of \(user) detected")

        let starredRepoCount = starrableRepos.map { repo -> Result<Void, GitHubClient.Error> in
            dumpInfo("Star to \(repo.fullName)")
            return gitHubClient.star(userId: user.login, repo: repo.name)
        }
        .reduce(into: 0) {
            switch $1 {
            case .success:
                $0 += 1
            case let .failure(error):
                dumpError(error)
            }
        }

        dumpInfo("\(starredRepoCount) repos of \(user) starred!")
    }

    func fetchAllRepos(of user: User) throws -> [Repo] {
        var page: UInt = 1
        var repos: [Repo] = []
        while true {
            let reposPerPage = try gitHubClient.getRepos(for: user.login, page: page).get()
            if reposPerPage.isEmpty { break }
            repos += reposPerPage
            page += 1
        }
        return repos
    }
}

private extension SSGHCore {
    func confirmUpdate() {
        guard case let .success(releases) = gitHubClient.getReleases(for: ApplicationInfo.author, repo: ApplicationInfo.name) else { return }
        guard let latest = releases.map({ Version(stringLiteral: $0.tagName) }).max()
            else { return }
        if ApplicationInfo.version < latest {
            dumpInfo("New version \(latest) is available!")
        }
    }
}

public extension SSGHCore {
    enum Mode {
        case specifiedTargets([String])
        // TODO: Future support
        // case following
    }
}
