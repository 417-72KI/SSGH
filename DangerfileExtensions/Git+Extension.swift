import Danger

extension Git {
    var linesOfCode: Int {
        createdFiles.count + modifiedFiles.count - deletedFiles.count
    }
}
