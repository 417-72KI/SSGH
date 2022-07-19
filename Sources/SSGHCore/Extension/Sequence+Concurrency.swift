import Foundation

// ref: https://www.swiftbysundell.com/articles/async-and-concurrent-forEach-and-map
extension Sequence {
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }

    func asyncFilter(
        _ isIncluded: (Element) async throws -> Bool
    ) async rethrows -> [Element] {
        var values = [Element]()

        for element in self where try await isIncluded(element) {
            values.append(element)
        }

        return values
    }
}
