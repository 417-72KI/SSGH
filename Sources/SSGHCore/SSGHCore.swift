import Foundation

public struct SSGHCore {
    let target: String
    let gitHubToken: String

    public init(target: String, gitHubToken: String) {
        self.target = target
        self.gitHubToken = gitHubToken
    }
}

public extension SSGHCore {
    func execute() throws {
    }
}
