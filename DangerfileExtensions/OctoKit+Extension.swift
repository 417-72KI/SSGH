import Danger
import OctoKit
import RequestKit

extension Octokit {
    @discardableResult
    func postReview(
        owner: String,
        repository: String,
        pullRequestNumber: Int,
        commitId: String? = nil,
        event: Review.Event,
        body: String? = nil,
        comments: [Review.Comment] = []
    ) async throws -> Review {
        let router = ReviewRouter.postReview(configuration, owner, repository, pullRequestNumber, commitId, event, body, comments)
        return try await router.load(dateDecodingStrategy: .formatted(Time.rfc3339DateFormatter), expectedResultType: Review.self)
    }
}

// MARK: -
extension Review {
    enum Event: String, Codable {
        case approve = "APPROVE"
        case requestChanges = "REQUEST_CHANGES"
        case comment = "COMMENT"
        case pending = "PENDING"
    }

    struct Comment: Codable {
        var path: String
        var position: Int?
        var body: String
        var line: Int?
        var side: String?
        var startLine: Int?
        var startSide: String?
    }
}

extension Review.Comment {
    enum CodingKeys: String, CodingKey {
        case path
        case position
        case body
        case line
        case side
        case startLine = "start_line"
        case startSide = "start_side"
    }
}

// MARK: -
private enum ReviewRouter {
    // swiftlint:disable:next enum_case_associated_values_count discouraged_optional_collection
    case postReview(Configuration, String, String, Int, String?, Review.Event?, String?, [Review.Comment]?)
}

extension ReviewRouter: JSONPostRouter {
    var method: HTTPMethod { .POST }
    var encoding: HTTPEncoding { .json }
    var configuration: Configuration {
        switch self {
        case let .postReview(config, _, _, _, _, _, _, _):
            return config
        }
    }

    var params: [String: Any] {
        switch self {
        case let .postReview(_, _, _, _, commitId, event, body, comments):
            var parameters = [String: Any]()
            if let commitId = commitId {
                parameters["commit_id"] = commitId
            }
            if let event = event {
                parameters["event"] = event.rawValue
            }
            if let body = body {
                parameters["body"] = body
            }
            if let comments = comments {
                parameters["comments"] = comments.map { comment -> [String: Any] in
                    var parameters: [String: Any] = [
                        "path": comment.path,
                        "body": comment.body
                    ]
                    if let position = comment.position {
                        parameters["position"] = position
                    }
                    if let line = comment.line {
                        parameters["line"] = line
                    }
                    if let side = comment.side {
                        parameters["side"] = side
                    }
                    if let startLine = comment.startLine {
                        parameters["start_line"] = startLine
                    }
                    if let startSide = comment.startSide {
                        parameters["start_side"] = startSide
                    }
                    return parameters
                }
            }
            return parameters
        }
    }

    var path: String {
        switch self {
        case let .postReview(_, owner, repository, pullRequestNumber, _, _, _, _):
            return "repos/\(owner)/\(repository)/pulls/\(pullRequestNumber)/reviews"
        }
    }
}
