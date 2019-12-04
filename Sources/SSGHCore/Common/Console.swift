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

private var tag: String {
    return "[\(ApplicationInfo.name)(\(ApplicationInfo.version))] "
}
