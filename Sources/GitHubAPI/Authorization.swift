import Foundation

@available(*, deprecated, message: "to be replaced by OctoKit")
final class Authorization {
    static let shared: Authorization = .init()

    var token: String = ""

    private init() {}
}
