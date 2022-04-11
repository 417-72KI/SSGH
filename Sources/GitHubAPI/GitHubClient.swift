import Foundation
import OctoKit

public class GitHubClient {
    let domain = "https://github.com"

    let octoKit: Octokit

    public init(token: String) {
        octoKit = .init(.init(token))
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
