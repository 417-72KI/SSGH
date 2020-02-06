import Foundation
import OctoKit

public struct Repo: Entity {
    public let id: Int
    public let name: String
    public let fullName: String
    public let fork: Bool

    let `private`: Bool
    let htmlUrl: String
    let description: String?
}

extension Repo {
    init(_ repo: OctoKit.Repository) {
        self.id = repo.id
        self.name = repo.name ?? ""
        self.fullName = repo.fullName ?? ""
        self.fork = repo.isFork
        self.private = repo.isPrivate
        self.htmlUrl = repo.htmlURL ?? ""
        self.description = repo.repositoryDescription
    }
}
