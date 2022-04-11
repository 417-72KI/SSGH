import ArgumentParser
import Foundation
import SSGHCore

#if swift(<5.6)
// https://github.com/apple/swift-argument-parser/pull/404
@main
enum Main: AsyncMainProtocol {
    typealias Command = SSGH
}

struct SSGH: AsyncParsableCommand {
    @Argument(help: "GitHub user name to give stars.")
    var target: String

    @Option(name: [.customLong("github-token"), .customShort("t")],
            help: "GitHub Token to give stars. If not set, use `SSGH_TOKEN` in environment.")
    var gitHubToken: String?

    @Flag(name: .short, help: "dry-run mode. Only fetch lists to give stars.")
    var dryRunMode = false
}
#else
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
#endif

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
            try await core.execute(mode: .specifiedTargets(targets))
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
