import Foundation

extension SSGHCore {
    enum Error {
        case targetUnspecified
    }
}

extension SSGHCore.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .targetUnspecified:
            return "Specify at least one target."
        @unknown default:
            return nil
        }
    }
}
