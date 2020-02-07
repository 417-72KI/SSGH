import Foundation

public struct User: Entity {
    public let login: String
    public let publicRepos: UInt
}

extension User: CustomStringConvertible {
    public var description: String { "@\(login)" }
}
