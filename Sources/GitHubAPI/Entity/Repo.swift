import Foundation

public struct Repo: Entity {
    public let id: Int
    let nodeId: String
    public let name: String
    public let fullName: String

    let `private`: Bool
    let htmlUrl: String
    let description: String?
    let fork: Bool
}
