import Foundation

public struct User: Entity {
    public let login: String
    public let publicRepos: UInt
    public let reposUrl: String
    public let starredUrl: String
}
