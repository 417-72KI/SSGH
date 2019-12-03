import Commander
import Foundation
import SSGHCore

enum Arguments {
    static let target = Argument<String>(
        "target",
        description: "GitHub user name to give stars."
    )
}

enum Flags {
    static let version = Flag(
        "version",
        flag: "v",
        description: "Display current version."
    )
}

let main = command(
    Flags.version,
    Arguments.target
) {
    if $0 {
        print(ApplicationInfo.version)
        return
    }

    do {
        try SSGHCore(target: $1).execute()
    } catch {
        dumpError(error)
        exit(1)
    }
}

main.run(ApplicationInfo.version)
