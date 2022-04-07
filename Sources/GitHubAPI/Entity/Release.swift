import Foundation
import OctoKit

public struct Release: Entity {
    public let url: URL
    public let name: String
    public let tagName: String
    public let prerelease: Bool
    public let draft: Bool
}

extension Release {
    init(_ release: OctoKit.Release) {
        self.url = release.url
        self.name = release.name
        self.tagName = release.tagName
        self.prerelease = release.prerelease
        self.draft = release.draft
    }
}
