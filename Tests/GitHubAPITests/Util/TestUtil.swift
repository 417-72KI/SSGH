import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import OHHTTPStubs
import OHHTTPStubsSwift
import RequestKit
import XCTest

// MARK: - Stub

@available(*, deprecated, message: "Will be removed. Use `StubURLSession` instead.")
func stubGetRequest(host: String = "api.github.com",
                    path: String,
                    responseData: Any) {
    stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
        HTTPStubsResponse(jsonObject: responseData,
                          statusCode: 200,
                          headers: ["Content-Type": "application/json"])
    }
}

@available(*, deprecated, message: "Will be removed. Use `StubURLSession` instead.")
func stubGetRequest(host: String = "api.github.com",
                    path: String,
                    responseFileName: String) {
    stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
        guard let path = OHPathForFileInBundle("Resources/stub/\(responseFileName)", .module) else {
            return HTTPStubsResponse(error: URLError(.fileDoesNotExist))
        }
        return HTTPStubsResponse(fileAtPath: path,
                                 statusCode: 200,
                                 headers: ["Content-Type": "application/json"])
    }
}

@available(*, deprecated, message: "Will be removed. Use `StubURLSession` instead.")
func stubGetRequest(host: String = "api.github.com",
                    path: String,
                    statusCode: Int32) {
    stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
        HTTPStubsResponse(data: .init(), statusCode: statusCode, headers: [:])
    }
}

@available(*, deprecated, message: "Will be removed. Use `StubURLSession` instead.")
func stubPutRequest(host: String = "api.github.com",
                    path: String,
                    statusCode: Int32) {
    stub(condition: isHost(host) && isPath(path) && isMethodPUT()) { _ in
        HTTPStubsResponse(data: .init(), statusCode: statusCode, headers: [:])
    }
}

@available(*, deprecated, message: "Will be removed. Use `StubURLSession` instead.")
func stubDeleteRequest(host: String = "api.github.com",
                       path: String,
                       statusCode: Int32) {
    stub(condition: isHost(host) && isPath(path) && isMethodDELETE()) { _ in
        HTTPStubsResponse(data: .init(), statusCode: statusCode, headers: [:])
    }
}

@available(*, deprecated, message: "Will be removed. Use `StubURLSession` instead.")
func clearStubs() {
    HTTPStubs.removeAllStubs()
}

// MARK: -
final class StubURLSession: RequestKitURLSession {
    let expectedURL: URL
    let expectedHTTPMethod: HTTPMethod
    let responseData: Data?
    let statusCode: Int
    let file: StaticString
    let line: UInt
    private(set) var wasCalled = false

    init(host: String = "api.github.com",
         path: String,
         method: HTTPMethod,
         responseData: Data? = nil,
         statusCode: Int = 200,
         file: StaticString = #file,
         line: UInt = #line) {
        self.expectedURL = {
            var comps = URLComponents()
            comps.scheme = "https"
            comps.host = host
            comps.path = path
            return comps.url!
        }()
        self.expectedHTTPMethod = method
        self.responseData = responseData
        self.statusCode = statusCode
        self.file = file
        self.line = line
    }
}

extension StubURLSession {
    convenience init(host: String = "api.github.com",
                     path: String,
                     method: HTTPMethod,
                     jsonFile: String,
                     statusCode: Int = 200,
                     file: StaticString = #file,
                     line: UInt = #line) {
        let data = Bundle.module
            .path(forResource: "Resources/stub/\(jsonFile)", ofType: "json")
            .flatMap(URL.init(fileURLWithPath:))
            .flatMap { try? Data(contentsOf: $0) }
        self.init(host: host,
                  path: path,
                  method: method,
                  responseData: data,
                  statusCode: statusCode,
                  file: file,
                  line: line)
    }
}

extension StubURLSession {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }

    enum StubError: LocalizedError {
        case unexpectedRequest(expected: (HTTPMethod, URL), actual: (HTTPMethod, URL))

        var errorDescription: String? {
            switch self {
            case let .unexpectedRequest(expected, actual):
                return """
                    Unexpected request.
                        Expected: \(expected.0.rawValue) \(expected.1)
                        Actual: \(actual.0.rawValue) \(actual.1)
                    """
            }
        }
    }
}

extension StubURLSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        defer { wasCalled = true }
        do {
            let url = try XCTUnwrap(request.url, file: file, line: line)
            let httpMethod = try XCTUnwrap(request.httpMethod.flatMap(HTTPMethod.init), file: file, line: line)
            guard url.host == expectedURL.host,
                  url.path == expectedURL.path,
                  httpMethod == expectedHTTPMethod else {
                      throw StubError.unexpectedRequest(
                        expected: (expectedHTTPMethod, expectedURL),
                        actual: (httpMethod, url)
                      )
                  }
            let response = HTTPURLResponse(url: url,
                                           statusCode: statusCode,
                                           httpVersion: "http/1.1",
                                           headerFields: ["Content-Type": "application/json"])
            completionHandler(responseData, response, nil)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
            completionHandler(nil, nil, error)
        }
        return StubURLSessionDataTask()
    }

    func uploadTask(with request: URLRequest, fromData bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        defer { wasCalled = true }
        do {
            let url = try XCTUnwrap(request.url, file: file, line: line)
            let httpMethod = try XCTUnwrap(request.httpMethod.flatMap(HTTPMethod.init), file: file, line: line)
            guard url.host == expectedURL.host,
                  url.path == expectedURL.path,
                  httpMethod == expectedHTTPMethod else {
                      throw StubError.unexpectedRequest(
                        expected: (expectedHTTPMethod, expectedURL),
                        actual: (httpMethod, url)
                      )
                  }
            let response = HTTPURLResponse(url: url,
                                           statusCode: statusCode,
                                           httpVersion: "http/1.1",
                                           headerFields: ["Content-Type": "application/json"])
            completionHandler(responseData, response, nil)
        } catch {
            XCTFail(error.localizedDescription, file: file, line: line)
            completionHandler(nil, nil, error)
        }
        return StubURLSessionDataTask()
    }

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        defer { wasCalled = true }

        let url = try XCTUnwrap(request.url, file: file, line: line)
        let httpMethod = try XCTUnwrap(request.httpMethod.flatMap(HTTPMethod.init), file: file, line: line)
        guard url.host == expectedURL.host,
              url.path == expectedURL.path,
              httpMethod == expectedHTTPMethod else {
                  throw StubError.unexpectedRequest(
                    expected: (expectedHTTPMethod, expectedURL),
                    actual: (httpMethod, url)
                  )
              }
        let data = try XCTUnwrap(responseData, file: file, line: line)
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: "http/1.1",
                headerFields: ["Content-Type": "application/json"]
            ),
            file: file,
            line: line
        )
        return (data, response)
    }

    func upload(for request: URLRequest, from bodyData: Data, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        defer { wasCalled = true }

        let url = try XCTUnwrap(request.url, file: file, line: line)
        let httpMethod = try XCTUnwrap(request.httpMethod.flatMap(HTTPMethod.init), file: file, line: line)
        guard url.host == expectedURL.host,
              url.path == expectedURL.path,
              httpMethod == expectedHTTPMethod else {
                  throw StubError.unexpectedRequest(
                    expected: (expectedHTTPMethod, expectedURL),
                    actual: (httpMethod, url)
                  )
              }
        let data = try XCTUnwrap(responseData, file: file, line: line)
        let response = try XCTUnwrap(
            HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: "http/1.1",
                headerFields: ["Content-Type": "application/json"]
            ),
            file: file,
            line: line
        )
        return (data, response)
    }
}

final class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var wasResumeCalled = false

    func resume() {
        wasResumeCalled = true
    }
}

// MARK: - Concurrency
#if compiler(>=5.5.2) && canImport(_Concurrency)
extension XCTest {
    func XCTAssertThrowsErrorAsync<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail(message(), file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }

    func XCTAssertNoThrowAsync<T: Sendable>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await expression()
        } catch {
            XCTFail(message(), file: file, line: line)
        }
    }
}
#endif
