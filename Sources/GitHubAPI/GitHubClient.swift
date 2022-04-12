import Foundation
import OctoKit
import RequestKit

public class GitHubClient {
    let domain = "https://github.com"

    let octoKit: Octokit
    let session: RequestKitURLSession

    public init(token: String, session: RequestKitURLSession = URLSession.shared) {
        octoKit = .init(.init(token))
        self.session = session
    }
}
