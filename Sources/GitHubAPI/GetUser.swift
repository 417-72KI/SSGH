import APIKit
import Foundation
import RxSwift

extension GitHubAPI {
    public func getUser(by userId: String) -> Result<User, GitHubAPI.Error> {
        sendSync(Users.Get(userId: userId))
    }
}

extension GitHubAPI {
    enum Users {
        struct Get: Request {
            typealias Response = User

            let userId: String

            var method: HTTPMethod { .get }
            var path: String { "/users/\(userId)" }
        }
    }
}
