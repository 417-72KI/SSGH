import ArgumentParser
import Foundation
import SSGHCore

@main
struct SSGH: ParsableCommand {
    @Argument(help: "GitHub user name to give stars.")
    var targets: [String]

    @Option(name: [.customLong("github-token"), .customShort("t")],
            help: "GitHub Token to give stars. If not set, use `SSGH_TOKEN` in environment.")
    var gitHubToken: String?

    @Flag(name: .short, help: "dry-run mode. Only fetch lists to give stars.")
    var dryRunMode = false
}

extension SSGH {
    static var configuration: CommandConfiguration {
        CommandConfiguration(version: ApplicationInfo.version.description)
    }
}

extension SSGH {
    func run() throws {
        let gitHubToken = try gitHubToken ?? (try Environment.getValue(forKey: .gitHubToken))
        do {
            try SSGHCore(
                gitHubToken: gitHubToken,
                dryRunMode: dryRunMode
            ).execute(mode: . specifiedTargets(targets))
        } catch {
            dumpError(error)
            Self.exit(withError: error)
        }
    }
}
