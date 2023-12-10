import Foundation

extension Sequence {
    func sorted<Comparator: SortComparator, T>(using comparator: Comparator, by keyPath: KeyPath<Element, T>) -> [Element] where T == Comparator.Compared {
        sorted(by: { comparator.compare($0[keyPath: keyPath], $1[keyPath: keyPath]) == .orderedAscending })
    }
}
