import Commander
import Foundation
import SSGHCore

enum Arguments {
    static let target = Argument<String>(
        "target",
        description: "GitHub user name to give stars."
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
    Options.gitHubToken,
    Arguments.target
) {
    let gitHubToken = try $0 ?? (try Environment.getValue(forKey: .gitHubToken))

    do {
        try SSGHCore(target: $1, gitHubToken: gitHubToken).execute()
    } catch {
        dumpError(error)
        exit(1)
    }
}

main.run(ApplicationInfo.version)