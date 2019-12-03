import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        precondition(!value.isEmpty)
        self.init(string: value)!
    }
}
