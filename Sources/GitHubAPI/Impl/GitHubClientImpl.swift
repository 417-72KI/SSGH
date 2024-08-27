import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import OctoKit
import RequestKit

public func defaultGitHubClient(
    token: String,
    session: any RequestKitURLSession = URLSession.shared
) -> GitHubClient {
    GitHubClientImpl(token: token, session: session)
}

final class GitHubClientImpl: GitHubClient {
    let domain = "https://github.com"

    let octoKit: Octokit

    init(token: String, session: any RequestKitURLSession) {
        octoKit = .init(.init(token), session: session)
    }
}
