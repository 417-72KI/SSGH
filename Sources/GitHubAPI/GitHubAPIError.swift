import Foundation

public enum GitHubAPIError: LocalizedError {
    case userNotFound(String)
    case repoNotFound(String)
    case other(Swift.Error)
}

extension GitHubAPIError {
    public var errorDescription: String? {
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
