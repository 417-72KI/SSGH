import APIKit
import Foundation

#if canImport(RxSwift)
import RxSwift
#endif

public class GitHubAPI {
    let domain = "https://github.com"

    let token: String

    public init(token: String) {
        self.token = token
    }
}

extension GitHubAPI {
    func send<R: Request>(_ request: R, completionHandler: @escaping  (Result<R.Response, GitHubAPI.Error>) -> Void) {
        Session.send(request) { result in
            switch result {
            case let .success(entity):
                completionHandler(.success(entity))
            case let .failure(error):
                completionHandler(.failure(.other(error)))
            }
        }
    }
}

// MARK: - Request
protocol Request: APIKit.Request where Response: Entity {
    var token: String { get }
}

extension Request {
    var baseURL: URL { "https://api.github.com" }
}

extension Request {
    var headerFields: [String: String] {
        ["Authorization": "token \(token)"]
    }
}

extension Request {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

extension Request {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try decoder.decode(Response.self, from: data)
    }
}

// MARK: - Error
extension GitHubAPI {
    public enum Error: Swift.Error {
        case other(Swift.Error)
    }
}

// MARK: - Rx
#if canImport(RxSwift)
extension GitHubAPI: ReactiveCompatible {}

extension Reactive where Base == GitHubAPI {
    func send<R: Request>(_ request: R) -> Single<R.Response> {
        return .create { [base] event in
            base.send(request) { result in
                switch result {
                case let .success(entity):
                    event(.success(entity))
                case let .failure(error):
                    event(.error(error))
                }
            }

            return Disposables.create()
        }
    }
}
#endif
