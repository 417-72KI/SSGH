import ArgumentParser
import Foundation
import SSGHCore

@main
struct SSGH: AsyncParsableCommand {
    @Argument(help: "GitHub user name to give stars.")
    var targets: [String]

    @Option(name: [.customLong("github-token"), .customShort("t")],
            help: "GitHub Token to give stars. If not set, use `SSGH_TOKEN` in environment.")
    var gitHubToken: String?

    @Flag(name: [.customLong("dry-run"), .short], help: "dry-run mode. Only fetch lists to give stars.")
    var dryRunMode = false
}

extension SSGH {
    static var configuration: CommandConfiguration {
        CommandConfiguration(version: ApplicationInfo.version.description)
    }
}

extension SSGH {
    func run() async throws {
        let gitHubToken = try gitHubToken ?? (try Environment.getValue(forKey: .gitHubToken))
        let core = SSGHCore(
            gitHubToken: gitHubToken,
            dryRunMode: dryRunMode
        )
        do {
            try core.execute(mode: .specifiedTargets(targets))
            await confirmUpdate(core)
        } catch {
            dumpError(error)
            await confirmUpdate(core)
            Self.exit(withError: error)
        }
    }
}

private extension SSGH {
    func confirmUpdate(_ core: SSGHCore) async {
        guard let latest = await core.fetchLatest() else { return }
        dumpDebug(latest)
        if ApplicationInfo.version < latest {
            dumpWarn("New version \(latest) is available!")
        }
    }
}
