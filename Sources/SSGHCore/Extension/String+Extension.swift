import Foundation

extension String {
    var lastPathComponent: String {
        nsString.lastPathComponent
    }
}

extension String {
    func substring(_ range: NSRange) -> String {
        nsString.substring(with: range)
    }
}

// MARK: -
private extension String {
    // swiftlint:disable:next legacy_objc_type
    var nsString: NSString {
        // swiftlint:disable:next legacy_objc_type
        self as NSString
    }
}
