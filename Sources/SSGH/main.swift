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

enum Options {
    static let gitHubToken = Option<String?>(
        "github-token",
        default: nil,
        flag: "t",
        description: "GitHub Token"
    )
}

let main = command(
    Flags.version,
    Arguments.target,
    Options.gitHubToken
) {
    if $0 {
        print(ApplicationInfo.version)
        return
    }

    let gitHubToken = try $2 ?? (try Environment.getValue(forKey: .gitHubToken))

    do {
        try SSGHCore(target: $1, gitHubToken: gitHubToken).execute()
    } catch {
        dumpError(error)
        exit(1)
    }
}

main.run(ApplicationInfo.version)
