import Foundation

public struct Release: Entity {
    public let url: URL
    public let name: String
    public let tagName: String
    public let prerelease: Bool
    public let draft: Bool
}
