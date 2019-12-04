import Darwin
import Foundation

func dumpDebug(_ message: @autoclosure () -> String) {
    #if DEBUG
    fputs("[Debug] \(message())\n", stdout)
    #endif
}

func dumpInfo(_ message: @autoclosure () -> String) {
    fputs("[Info] \(message())\n", stdout)
}
