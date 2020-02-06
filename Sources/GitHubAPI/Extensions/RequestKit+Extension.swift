import Foundation
import RequestKit

extension Response {
    var result: Result<T, Error> {
        switch self {
        case let .success(entity):
            return .success(entity)
        case let .failure(error):
            return .failure(error)
        }
    }
}
