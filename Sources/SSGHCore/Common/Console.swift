import Darwin
import Foundation

func dumpDebug(_ message: @autoclosure () -> String) {
    #if DEBUG
    fputs("\(tag)[Debug] \(message())\n", stdout)
    #endif
}

public func dumpInfo(_ message: @autoclosure () -> String) {
    fputs("\(tag)[Info] \(message())\n", stdout)
}

public func dumpError(_ message: @autoclosure () -> String) {
    fputs("\(tag)[Error] \(message())\n", stderr)
}

public func dumpError(_ error: @autoclosure () -> Error) {
    dumpError("\(error())")
}

public func dumpWarn(_ message: @autoclosure () -> String) {
    fputs("\(tag)[Warning] \(message())\n", stderr)
}

private func dump(logType: LogType,
                  _ message: @autoclosure () -> String,
                  file: StaticString,
                  line: UInt) {
    let message = String(format: "%@%@[%@] %@%@\n",
                         logType.color.rawValue,
                         tag,
                         logType.rawValue.uppercased(),
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
}

extension ConsoleColor {
    static var reset: Self { .white }
}

// MARK: -
private var tag: String { "[\(ApplicationInfo.name)(\(ApplicationInfo.version))] " }
