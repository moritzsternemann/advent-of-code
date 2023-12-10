struct Day08: Solution {
    static let day = 08

    private let instructions: [Instruction]
    private let graph: [String: (left: String, right: String)]

    init(input: String) {
        let sections = input.split(separator: "\n\n")

        self.instructions = sections[0].compactMap { Instruction(rawValue: $0) }
        self.graph = sections[1].split(separator: "\n")
            .reduce(into: [:]) { graph, line in
                guard let match = line.wholeMatch(of: #/(\w{3}) = \((\w{3}), (\w{3})\)/#) else { return }
                graph[String(match.output.1)] = (String(match.output.2), String(match.output.3))
            }
    }

    func runPartOne() -> Int {
        var currentNode = "AAA"
        var stepCount = 0

        while currentNode != "ZZZ" {
            guard let node = graph[currentNode] else { fatalError() }

            switch instructions[stepCount % instructions.count] {
            case .left:
                currentNode = node.left
            case .right:
                currentNode = node.right
            }

            stepCount += 1
        }

        return stepCount
    }

    func runPartTwo() -> Int {
        let startNodes = Set(graph.keys.filter { $0.hasSuffix("A") })
        var stepCountsByNode: [Int] = []

        for var currentNode in startNodes {
            var stepCount = 0

            while !currentNode.hasSuffix("Z") {
                for instruction in instructions {
                    guard let node = graph[currentNode] else { fatalError() }
                    stepCount += 1
                    switch instruction {
                    case .left:
                        currentNode = node.left
                    case .right:
                        currentNode = node.right
                    }
                }
            }

            stepCountsByNode.append(stepCount)
        }

        // least common multiple
        return stepCountsByNode.lcm()
    }
}

extension Day08 {
    enum Instruction: Character {
        case left = "L", right = "R"
    }

    class Node {
        let label: String
        let left: Node
        let right: Node

        init(label: String, left: Node, right: Node) {
            self.label = label
            self.left = left
            self.right = right
        }
    }
}
