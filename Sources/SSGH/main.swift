import Commander
import Foundation
import SSGHCore

enum Arguments {
    static let targets = Argument<[String]>(
        "targets",
        description: "GitHub user name to give stars."
    )
}

enum Options {
    static let gitHubToken = Option<String?>(
        "github-token",
        default: nil,
        flag: "t",
        description: "GitHub Token to give stars. If not set, use `SSGH_TOKEN` in environment."
    )
}

let main = command(
    Options.gitHubToken,
    Arguments.targets
) {
    let gitHubToken = try $0 ?? (try Environment.getValue(forKey: .gitHubToken))
    let targets = $1

    do {
        try SSGHCore(gitHubToken: gitHubToken)
            .execute(mode: .specifiedTargets(targets))
    } catch {
        dumpError(error)
        exit(EXIT_FAILURE)
    }
}

main.run(ApplicationInfo.version.description)
