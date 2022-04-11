#if os(macOS)
import Darwin
#elseif os(Linux)
import Glibc
#endif
import Foundation

func dumpDebug(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
    dump(logType: .debug, message(), file: file, line: line)
    #endif
}

func dumpDebug(_ message: @autoclosure () -> Any, file: StaticString = #file, line: UInt = #line) {
    dumpDebug(String(describing: message()), file: file, line: line)
}

public func dumpInfo(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    dump(logType: .info, message(), file: file, line: line)
}

public func dumpError(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    dump(logType: .error, message(), file: file, line: line)
}

public func dumpError(_ error: @autoclosure () -> Error, file: StaticString = #file, line: UInt = #line) {
    dumpError("\(error())", file: file, line: line)
}

public func dumpWarn(_ message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    dump(logType: .warn, message(), file: file, line: line)
}

private func dump(
    logType: LogType,
    _ message: @autoclosure () -> String,
    file: StaticString,
    line: UInt
) {
    #if DEBUG
    let fileAndLine = " [\(String(describing: file).lastPathComponent):L\(line)]"
    #else
    let fileAndLine = ""
    #endif

    let message = String(
        format: "%@%@[%@]%@ %@%@\n",
        logType.color.rawValue,
        tag,
        logType.rawValue.uppercased(),
        fileAndLine,
        message(),
        ConsoleColor.reset.rawValue
    )
    fputs(message, logType.dumpTarget)
}

// MARK: -
private enum LogType: String {
    case debug
    case info
    case error
    case warn
}

extension LogType {
    var dumpTarget: UnsafeMutablePointer<FILE> {
        switch self {
        case .debug, .info: return stdout
        case .warn, .error: return stderr
        }
    }
    var color: ConsoleColor {
        switch self {
        case .info: return .green
        case .warn: return .yellow
        case .error: return .red
        default: return .white
        }
    }
}

private enum ConsoleColor: String {
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case white = "\u{001B}[0;39m"
    case reset = "\u{001B}[0;m"
}

// MARK: -
private var tag: String { "[\(ApplicationInfo.name)(\(ApplicationInfo.version))] " }
