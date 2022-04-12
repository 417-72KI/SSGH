import Foundation
import OctoKit
import RequestKit

public func defaultGitHubClient(token: String, session: RequestKitURLSession = URLSession.shared) -> GitHubClient {
    GitHubClientImpl(token: token, session: session)
}

final class GitHubClientImpl: GitHubClient {
    let domain = "https://github.com"

    let octoKit: Octokit
    let session: RequestKitURLSession

    init(token: String, session: RequestKitURLSession) {
        octoKit = .init(.init(token))
        self.session = session
    }
}
