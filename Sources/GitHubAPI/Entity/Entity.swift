import Foundation

#if compiler(>=5.5.2) && canImport(_Concurrency)
protocol Entity: Decodable, Hashable, Sendable {
}
#else
protocol Entity: Decodable, Hashable {
}
#endif

extension Array: Entity where Element: Entity {
}

extension Dictionary: Entity where Key == String, Value: Entity {
}

struct EmptyEntity: Entity, @unchecked Sendable {
    let response: HTTPURLResponse

    init(response: HTTPURLResponse) {
        self.response = response
    }

    init(from decoder: Decoder) throws {
        throw DecodingError.typeMismatch(EmptyEntity.self, .init(codingPath: [], debugDescription: ""))
    }
}
