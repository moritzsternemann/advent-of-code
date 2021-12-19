//
//  Sequence+toSet.swift
//  Common
//
//  Created by Moritz Sternemann on 19.12.21.
//

extension Sequence where Element: Hashable {
    public func toSet() -> Set<Element> {
        Set(self)
    }
}
