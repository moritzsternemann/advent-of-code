//
//  Input.swift
//  Common
//
//  Created by Moritz Sternemann on 06.12.21.
//

import Foundation

public enum Input {
    public static func loadInput(filename: String = "input", in bundle: Bundle) throws -> String {
        return try loadFileFromBundle(bundle, filename: filename)
    }
    
    public static func loadSampleInput(filename: String = "input_sample", in bundle: Bundle) throws -> String {
        return try loadFileFromBundle(bundle, filename: filename)
    }
    
    private static func loadFileFromBundle(_ bundle: Bundle, filename: String) throws -> String {
        let url = bundle.url(forResource: filename, withExtension: "txt")!
        let inputData = try Data(contentsOf: url)
        return String(decoding: inputData, as: UTF8.self)
    }
}
