import Foundation

final class Authorization {
    static let shared: Authorization = .init()

    var token: String = ""

    private init() {}
}
