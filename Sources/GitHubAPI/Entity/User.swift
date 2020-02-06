import Foundation
import OctoKit

public struct User: Entity {
    public let login: String
    public let publicRepos: UInt
}

extension User: CustomStringConvertible {
    public var description: String { "@\(login)" }
}

extension User {
    init(_ user: OctoKit.User) {
        self.login = user.login ?? ""
        self.publicRepos = UInt(user.numberOfPublicRepos ?? 0)
    }
}
