import APIKit
import Foundation
import RxSwift

extension GitHubClient {
    public func getUser(by userId: String) -> Result<User, GitHubClient.Error> {
        sendSync(Users.Get(userId: userId))
    }
}

extension GitHubClient {
    enum Users {
        struct Get: Request {
            typealias Response = User

            let userId: String

            var method: HTTPMethod { .get }
            var path: String { "/users/\(userId)" }
        }
    }
}
