//
//  RandomAccessCollection+safe.swift
//  Common
//
//  Created by Moritz Sternemann on 09.12.21.
//

extension RandomAccessCollection {
    public subscript(safe position: Index) -> Element? {
        guard position >= startIndex, position < endIndex else { return nil }
        return self[position]
    }
}
