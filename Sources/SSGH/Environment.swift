import Foundation

public struct Environment {
    private init() {}
}

public extension Environment {
    static func getValue(forKey key: Key) throws -> String {
        guard let value = ProcessInfo().environment[key.rawValue] else {
            throw Error.notFound(key)
        }
        return value
    }
}

extension Environment {
    public enum Key {
        case gitHubToken
    }
}

extension Environment.Key {
    public var rawValue: String {
        switch self {
        case .gitHubToken: return "SSGH_TOKEN"
        }
    }
}

extension Environment {
    public enum Error: Swift.Error {
        case notFound(Key)
    }
}

extension Environment.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notFound(let key):
            return "Missing value for `\(key.rawValue)` in environment."
        }
    }
}
