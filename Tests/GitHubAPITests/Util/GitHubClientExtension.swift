import Foundation
@testable import GitHubAPI

extension GitHubAPIError: Equatable {
    public static func == (lhs: GitHubAPIError, rhs: GitHubAPIError) -> Bool {
        switch (lhs, rhs) {
        case let (.userNotFound(lhs), .userNotFound(rhs)):
            return lhs == rhs
        case let (.repoNotFound(lhs), .repoNotFound(rhs)):
            return lhs == rhs
        case let (.other(lhs), .other(rhs)):
            return (lhs as NSError) == (rhs as NSError)
        default: return false
        }
    }
}
