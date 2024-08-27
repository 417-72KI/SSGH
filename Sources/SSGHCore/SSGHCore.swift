import Foundation
import GitHubAPI

public struct SSGHCore {
    let gitHubClient: any GitHubClient
    let dryRunMode: Bool
}

public extension SSGHCore {
    init(gitHubToken: String, dryRunMode: Bool = false) {
        gitHubClient = defaultGitHubClient(token: gitHubToken)
        self.dryRunMode = dryRunMode
    }
}

public extension SSGHCore {
    func execute(mode: Mode) async throws {
        switch mode {
        case let .specifiedTargets(targets):
            if targets.isEmpty { throw Error.targetUnspecified }
            dumpInfo("Fetching users...")

            for target in targets {
                do {
                    let user = try await gitHubClient.getUser(by: target)
                    try await star(to: user)
                } catch {
                    dumpWarn(error)
                }
            }
        }
    }
}

private extension SSGHCore {
    func star(to user: User) async throws {
        dumpInfo("Fetching repos for \(user)...")
        let repos = try await fetchAllRepos(of: user)
        let starrableRepos = try await repos.filter { !$0.fork }
            .asyncFilter { !(try await gitHubClient.isStarred(userId: user.login, repo: $0.name)) }
        dumpDebug("\(starrableRepos.count) \(starrableRepos.count == 1 ? "repo" : "repos") of \(user) detected")

        let starredRepoCount = await starrableRepos.asyncFilter { repo in
            dumpInfo("Starring \(repo.fullName)")
            if dryRunMode {
                dumpWarn("Dry-run mode. Simulate starring \"\(repo.fullName)\"")
                return true
            }
            do {
                try await gitHubClient.star(userId: user.login, repo: repo.name)
                return true
            } catch {
                dumpError(error)
                return false
            }
        }
        .count

        dumpInfo("\(starredRepoCount) \(starredRepoCount == 1 ? "repo" : "repos") of \(user) starred!")
    }

    func fetchAllRepos(of user: User) async throws -> [Repo] {
        var page: UInt = 1
        var repos: [Repo] = []
        while true {
            let reposPerPage = try await gitHubClient.getRepos(for: user.login, page: page)
            if reposPerPage.isEmpty { break }
            repos += reposPerPage
            page += 1
        }
        return repos
    }
}

// FIXME: Extract (to version manager?)
public extension SSGHCore {
    func fetchLatest() async -> Version? {
        do {
            let releases = try await gitHubClient.getReleases(for: ApplicationInfo.author, repo: ApplicationInfo.name)
            guard let latest = releases
                .filter({ !$0.prerelease })
                .map(\.tagName)
                .map(Version.init(stringLiteral:))
                .max() else { return nil }
            return latest
        } catch {
            dumpWarn(error.localizedDescription)
            return nil
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
