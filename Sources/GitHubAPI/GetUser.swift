import APIKit
import Foundation
import RxSwift

extension GitHubAPI {
    enum Users {
        struct Get: Request {
            typealias Response = User

            let token: String
            let userId: String

            var method: HTTPMethod { .get }
            var path: String { "/users/\(userId)" }
        }
    }
}

#if canImport(RxSwift)
extension Reactive where Base == GitHubAPI {
    public func getUser(by userId: String) -> Single<User> {
        send(Base.Users.Get(token: base.token, userId: userId))
    }
}
#endif
