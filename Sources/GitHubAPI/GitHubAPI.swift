import APIKit
import Foundation

public class GitHubAPI {
    let domain = "https://github.com"

    let token: String

    public init(token: String) {
        self.token = token
    }
}
