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

// MARK: - Error
extension GitHubClient {
    public enum Error: Swift.Error {
        case userNotFound(String)
        case repoNotFound(String)
        case other(Swift.Error)
    }
}

extension GitHubClient.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .userNotFound(userId):
            return "User(\(userId)) not found."
        case let .repoNotFound(repo):
            return "Repo(\(repo)) not found"
        case let .other(error):
            return "Unexpected error. Origin: \(error)."
        }
    }
}
