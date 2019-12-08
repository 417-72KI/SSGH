import Foundation

extension String {
    func substring(_ range: NSRange) -> String {
        (self as NSString).substring(with: range)
    }
}
