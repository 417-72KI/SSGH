import Danger

let danger = Danger()

// fileImport: DangerfileExtensions/Git+Extension.swift

SwiftLint.lint(inline: true)

// Make it more obvious that a PR is a work in progress and shouldn't be merged yet
if let github = danger.github {
    if github.pullRequest.title.lowercased().contains("[wip]") {
        danger.warn("PR is classed as Work in Progress")
    }
}

// Warn when there is a big PR
if danger.git.linesOfCode > 500 {
    danger.warn("Big PR")
}

if danger.git.modifiedFiles.contains("LICENSE") {
    danger.fail("Do not modify LICENSE !!")
}

if danger.git.deletedFiles.contains("LICENSE") {
    danger.fail("Do not delete LICENSE !!")
}
