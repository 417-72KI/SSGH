import Foundation

public struct Repo: Entity {
    public let id: Int
    let nodeId: String
    public let name: String
    public let fullName: String
    public let fork: Bool

    let `private`: Bool
    let htmlUrl: String
    let description: String?
}
