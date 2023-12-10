import Foundation

// Copied from Apple's swift-foundation because init(order:) is only
// available in macOS 14.0 and later in the SDK.
// https://github.com/apple/swift-foundation/blob/1bb0cbb9cb8c7863dc517731cd2c6bb9fca5a5fb/Sources/FoundationEssentials/SortComparator.swift
struct ComparableComparator<Compared: Comparable>: SortComparator {
    var order: SortOrder

    init(order: SortOrder = .forward) {
        self.order = order
    }

    private func unorderedCompare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
        if lhs < rhs { return .orderedAscending }
        if lhs > rhs { return .orderedDescending }
        return .orderedSame
    }

    func compare(_ lhs: Compared, _ rhs: Compared) -> ComparisonResult {
        unorderedCompare(lhs, rhs).withOrder(order)
    }
}

extension ComparisonResult {
    func withOrder(_ order: SortOrder) -> ComparisonResult {
        switch (order, self) {
        case (_, .orderedSame):
            return self
        case (.reverse, .orderedAscending):
            return .orderedDescending
        case (.reverse, .orderedDescending):
            return .orderedAscending
        case (.forward, _):
            return self
        }
    }
}
