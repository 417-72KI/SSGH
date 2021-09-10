import Foundation
import ArgumentParser
import SSGHCore

struct SSGH: ParsableCommand {
    @Argument(help: "GitHub user name to give stars.")
    var target: String

    @Option(name: [.long, .customShort("t")], parsing: .next, help: "GitHub Token to give stars. If not set, use `SSGH_TOKEN` in environment.")
    var gitHubToken: String?

    func run() throws {
        let gitHubToken = try gitHubToken ?? (try Environment.getValue(forKey: .gitHubToken))
        do {
            try SSGHCore(target: target, gitHubToken: gitHubToken).execute()
        } catch {
            dumpError(error)
            Self.exit(withError: error)
        }
    }
}

SSGH.main()
