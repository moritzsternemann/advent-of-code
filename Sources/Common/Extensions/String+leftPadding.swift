//
//  String+leftPadding.swift
//  Common
//
//  Created by Moritz Sternemann on 16.12.21.
//

extension String {
    public func leftPadding(toLength length: Int, withPad character: Character) -> String {
        if count < length {
            return String(repeating: character, count: length - count) + self
        } else {
            return String(suffix(length))
        }
    }
}
