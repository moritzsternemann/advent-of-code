//
//  main.swift
//  day12
//
//  Created by Moritz Sternemann on 12.12.21.
//

import Common

let input = try Input.loadInput(in: .module)
    .split(separator: "\n")
    .map(String.init)
    .reduce(into: Graph()) { graph, line in
        let edge = line.split(separator: "-")
        let from = Node(name: String(edge[0]))
        let to = Node(name: String(edge[1]))
        graph[from, default: []].append(to)
        graph[to, default: []].append(from)
    }

enum Node: Hashable {
    case start
    case end
    case named(String)
    
    init(name: String) {
        switch name {
        case "start":
            self = .start
        case "end":
            self = .end
        default:
            self = .named(name)
        }
    }
    
    var isBig: Bool {
        guard case let .named(name) = self else { return false }
        return name.allSatisfy(\.isUppercase)
    }
}

typealias Graph = [Node: [Node]]
typealias Path = [Node]

func findPaths(in graph: Graph, allowedToVisitTwice: Node?) -> Set<Path> {
    var paths = Set<Path>()
    
    func findPaths(currentPath: [Node]) {
        guard let last = currentPath.last, last != .end else {
            paths.insert(currentPath)
            return
        }
        
        let adjacents = graph[last, default: []]
            .filter { adjacent in
                if adjacent.isBig {
                    return true
                }
                if !currentPath.contains(adjacent) {
                    return true
                }
                if adjacent == allowedToVisitTwice && currentPath.filter({ $0 == allowedToVisitTwice }).count < 2 {
                    return true
                }
                return false
            }
        for adjacent in adjacents {
            findPaths(currentPath: currentPath + [adjacent])
        }
    }
    
    findPaths(currentPath: [.start])
    return paths
}

// MARK: - Part 1

let pathsPart1 = findPaths(in: input, allowedToVisitTwice: nil)
print("-- Part 1")
print("Path count: \(pathsPart1.count)")

// MARK: - Part 2

let pathsPart2 = input.keys
    .filter { !$0.isBig && $0 != .start && $0 != .end }
    .map { findPaths(in: input, allowedToVisitTwice: $0) }
    .reduce(Set<Path>()) { $0.union($1) }
print("-- Part 2")
print("Path count: \(pathsPart2.count)")
