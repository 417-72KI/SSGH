import Foundation

public struct Version {
    /// The major version.
    ///
    /// Increments to this component represent incompatible API changes.
    public let major: Int

    /// The minor version.
    ///
    /// Increments to this component represent backwards-compatible
    /// enhancements.
    public let minor: Int

    /// The patch version.
    ///
    /// Increments to this component represent backwards-compatible bug fixes.
    public let patch: Int

    /// The pre-release identifier
    ///
    /// Indicates that the version is unstable
    public let preRelease: String?

    /// The build metadata
    ///
    /// Build metadata is ignored when comparing versions
    public let buildMetadata: String?

    public init(_ major: Int, _ minor: Int, _ patch: Int, preRelease: String? = nil, buildMetadata: String? = nil) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.preRelease = preRelease
        self.buildMetadata = buildMetadata
    }
}

// MARK: - Public properties
extension Version {
    /// A list of the version components, in order from most significant to
    /// least significant.
    public var components: [Int] { [major, minor, patch] }

    /// Whether this is a prerelease version
    public var isPreRelease: Bool { preRelease != nil }
}

// MARK: - Hashable
extension Version: Hashable {
    public func hash(into hasher: inout Hasher) {
        components.forEach { hasher.combine($0) }
    }
}

// MARK: - Comparable
extension Version: Comparable {
    public static func < (_ lhs: Version, _ rhs: Version) -> Bool {
        if lhs.components == rhs.components {
            guard let lpr = lhs.preRelease else { return false }
            guard let rpr = rhs.preRelease else { return true }
            return lpr < rpr
        }
        return lhs.components.lexicographicallyPrecedes(rhs.components)
    }
}

// MARK: - CustomStringConvertible
extension Version: CustomStringConvertible {
    public var description: String {
        var description = components.map(String.init)
            .joined(separator: ".")
        if let preRelease = preRelease {
            description += "-\(preRelease)"
        }
        if let buildMetadata = buildMetadata {
            description += "+\(buildMetadata)"
        }
        return description
    }
}
