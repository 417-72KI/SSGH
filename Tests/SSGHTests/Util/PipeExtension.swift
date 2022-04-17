import Foundation

extension Pipe {
    func readString() -> String? {
        String(data: fileHandleForReading.readDataToEndOfFile(),
               encoding: .utf8)?
            .trimmingCharacters(in: .newlines)
    }
}
