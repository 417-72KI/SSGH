import Foundation
@testable import GitHubAPI

extension GitHubClient.Error: Equatable {
    public static func == (lhs: GitHubClient.Error, rhs: GitHubClient.Error) -> Bool {
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
