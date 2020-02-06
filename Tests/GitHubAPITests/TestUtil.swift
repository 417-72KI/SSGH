import Foundation
import OHHTTPStubs
import OHHTTPStubsSwift

func stubGetRequest(
    host: String = "api.github.com",
    path: String,
    responseData: Any
) {
    stub(condition: isHost(host) && isPath(path) && isMethodGET()) { _ in
        HTTPStubsResponse(jsonObject: responseData,
                          statusCode: 200,
                          headers: ["Content-Type": "application/json"])
    }
}

func clearStubs() {
    HTTPStubs.removeAllStubs()
}
