import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol Entity: Decodable, Hashable, Sendable {}

extension Array: Entity where Element: Entity {
}

extension Dictionary: Entity where Key == String, Value: Entity {
}

struct EmptyEntity: Entity {
    let response: HTTPURLResponse

    init(response: HTTPURLResponse) {
        self.response = response
    }

    init(from decoder: any Decoder) throws {
        throw DecodingError.typeMismatch(EmptyEntity.self, .init(codingPath: [], debugDescription: ""))
    }
}

extension EmptyEntity: @unchecked Sendable {}
