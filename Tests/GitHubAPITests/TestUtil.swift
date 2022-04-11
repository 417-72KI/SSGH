import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import OHHTTPStubs
import OHHTTPStubsSwift
import XCTest

// MARK: - Stub

func stubGetRequest(host: String = "api.github.com",
                    path: String,
                    responseData: Any) {
    stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
        HTTPStubsResponse(jsonObject: responseData,
                          statusCode: 200,
                          headers: ["Content-Type": "application/json"])
    }
}

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

func stubGetRequest(host: String = "api.github.com",
                    path: String,
                    statusCode: Int32) {
    stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
        HTTPStubsResponse(data: .init(), statusCode: statusCode, headers: [:])
    }
}

func stubPutRequest(host: String = "api.github.com",
                    path: String,
                    statusCode: Int32) {
    stub(condition: isHost(host) && isPath(path) && isMethodPUT()) { _ in
        HTTPStubsResponse(data: .init(), statusCode: statusCode, headers: [:])
    }
}

func stubDeleteRequest(host: String = "api.github.com",
                       path: String,
                       statusCode: Int32) {
    stub(condition: isHost(host) && isPath(path) && isMethodDELETE()) { _ in
        HTTPStubsResponse(data: .init(), statusCode: statusCode, headers: [:])
    }
}

func clearStubs() {
    HTTPStubs.removeAllStubs()
}

// MARK: - Concurrency
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
