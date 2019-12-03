import Foundation
import GitHubAPI

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
        let api = GitHubAPI(token: gitHubToken)
        let result = api.getUser(by: target)
        print(result)
    }
}
