import APIKit
import Foundation
import RxSwift

extension GitHubClient {
    public func getUser(by userId: String) -> Result<User, GitHubClient.Error> {
        sendSync(Users.Get(userId: userId))
            .mapError {
                if case let .responseError(re) = $0,
                    let responseError = re as? APIKit.ResponseError,
                    case let .unacceptableStatusCode(code) = responseError,
                    code == 404 { return .userNotFound(userId) }
                return .other($0)
        }
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
