import Foundation

extension String {
    func substring(_ range: NSRange) -> String {
        // swiftlint:disable:next legacy_objc_type
        (self as NSString).substring(with: range)
    }
}
