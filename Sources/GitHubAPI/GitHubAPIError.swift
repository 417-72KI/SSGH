import Foundation

public enum GitHubAPIError: Error {
    case userNotFound(String)
    case repoNotFound(String)
    case other(any Swift.Error)
}

extension GitHubAPIError: CustomStringConvertible {
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
