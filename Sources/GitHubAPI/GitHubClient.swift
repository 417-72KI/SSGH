import APIKit
import Foundation

public class GitHubClient {
    let domain = "https://github.com"

    public init(token: String) {
        Authorization.shared.token = token
    }
}

extension GitHubClient {
    func send<R: Request>(_ request: R, completionHandler: @escaping  (Result<R.Response, GitHubClient.Error>) -> Void) {
        Session.send(request, callbackQueue: .sessionQueue) { result in
            switch result {
            case let .success(entity):
                completionHandler(.success(entity))
            case let .failure(error):
                completionHandler(.failure(.other(error)))
            }
        }
    }

    func sendSync<T: Request>(_ request: T) -> Result<T.Response, GitHubClient.Error> {
        // swiftlint:disable:next implicitly_unwrapped_optional
        var result: Result<T.Response, GitHubClient.Error>!
        let semaphore = DispatchSemaphore(value: 0)
        send(request) {
            result = $0
            semaphore.signal()
        }
        semaphore.wait()
        return result
    }
}

// MARK: - Request
protocol Request: APIKit.Request where Response: Entity {
}

extension Request {
    var baseURL: URL { "https://api.github.com" }
}

extension Request {
    var headerFields: [String: String] {
        ["Authorization": "token \(Authorization.shared.token)"]
    }
}

extension Request {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}

struct DecodableDataParser: DataParser {
    var contentType: String? { "application/json" }

    func parse(data: Data) throws -> Any { data }
}

extension Request {
    var dataParser: DataParser { DecodableDataParser() }
}

extension Request {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        print(String(data: data, encoding: .utf8) ?? "")
        return try decoder.decode(Response.self, from: data)
    }
}

// MARK: - Error
extension GitHubClient {
    public enum Error: Swift.Error {
        case userNotFound
        case other(Swift.Error)
    }
}
