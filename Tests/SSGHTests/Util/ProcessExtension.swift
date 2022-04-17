import Foundation
import ArgumentParser

extension Process {
    var exitCode: ExitCode { .init(terminationStatus) }
}
