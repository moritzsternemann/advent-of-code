struct Day19: Solution {
    static let day = 19

    private let parts: [Part]
    private let workflows: [String: Workflow]

    init(input: String) {
        let sections = input.split(separator: "\n\n")

        self.workflows = sections[0]
            .split(separator: "\n")
            .reduce(into: [:]) { result, line in
                guard let workflow = Workflow(line) else { return }
                result[workflow.name] = workflow
            }

        self.parts = sections[1]
            .split(separator: "\n")
            .compactMap { Part($0) }
    }

    func runPartOne() -> Int {
        guard let startWorkflow = workflows["in"] else { fatalError("start workflow missing") }

        return parts
            .filter { evaluate($0, from: startWorkflow) }
            .map { $0.x + $0.m + $0.a + $0.s }
            .sum()
    }

    private func evaluate(_ part: Part, from startWorkflow: Workflow) -> Bool {
        var workflow = startWorkflow
        
        while true {
            evaluateWorkflow: for rule in workflow.rules {
                if let result = rule.evaluate(for: part) {
                    switch result {
                    case .workflow(let name):
                        guard let nextWorkflow = workflows[name] else { fatalError("destination workflow missing") }
                        workflow = nextWorkflow
                        break evaluateWorkflow
                    case .rejected:
                        return false
                    case .accepted:
                        return true
                    }
                }
            }
        }
    }

    func runPartTwo() -> Int {
        guard let startWorkflow = workflows["in"] else { fatalError("start workflow missing") }
        var initialConstraints: [KeyPath<Part, Int>: Constraint] = [
            \.x: Constraint(),
            \.m: Constraint(),
            \.a: Constraint(),
            \.s: Constraint()
        ]

        return countAccepted(for: startWorkflow, constraints: &initialConstraints)
    }

    private func countAccepted(for workflow: Workflow, constraints: inout [KeyPath<Part, Int>: Constraint]) -> Int {
        workflow.rules
            .map { countForOperation(of: $0, constraints: &constraints) }
            .sum()
    }

    private func countForOperation(of rule: Workflow.Rule, constraints: inout [KeyPath<Part, Int>: Constraint]) -> Int {
        if let condition = rule.condition {
            var newConstraints = constraints
            guard let constraint = constraints[condition.lhs] else { fatalError() }
            switch condition.operation {
            case .lessThan:
                newConstraints[condition.lhs] = constraint.lessThan(condition.rhs)
                constraints[condition.lhs] = constraint.moreThan(condition.rhs - 1)
            case .greaterThan:
                newConstraints[condition.lhs] = constraint.moreThan(condition.rhs)
                constraints[condition.lhs] = constraint.lessThan(condition.rhs + 1)
            }
            return countAccepted(for: rule, constraints: &newConstraints)
        }
        return countAccepted(for: rule, constraints: &constraints)
    }

    private func countAccepted(for rule: Workflow.Rule, constraints: inout [KeyPath<Part, Int>: Constraint]) -> Int {
        switch rule.destination {
        case .workflow(let name):
            guard let workflow = workflows[name] else { fatalError() }
            return countAccepted(for: workflow, constraints: &constraints)
        case .rejected:
            return 0
        case .accepted:
            return constraints.values
                .map(\.acceptedCount)
                .product()
        }
    }
}

extension Day19 {
    struct Part {
        var x: Int
        var m: Int
        var a: Int
        var s: Int

        init?(_ string: Substring) {
            guard let (_, x, m, a, s) = string.wholeMatch(of: #/\{x=(\d+),m=(\d+),a=(\d+),s=(\d+)\}/#)?.output,
                  let x = Int(x),
                  let m = Int(m),
                  let a = Int(a),
                  let s = Int(s)
            else { return nil }

            self.x = x
            self.m = m
            self.a = a
            self.s = s
        }
    }

    struct Workflow {
        enum Operation {
            case lessThan
            case greaterThan

            func evaluate(lhs: Int, rhs: Int) -> Bool {
                switch self {
                case .lessThan:
                    return lhs < rhs
                case .greaterThan:
                    return lhs > rhs
                }
            }
        }

        enum Destination {
            case workflow(String)
            case rejected
            case accepted

            init?(_ string: Substring) {
                self = switch string {
                case "A": .accepted
                case "R": .rejected
                default: .workflow(String(string))
                }
            }
        }

        struct Rule {
            var condition: (lhs: KeyPath<Part, Int>, rhs: Int, operation: Operation)?
            var destination: Destination

            init?(_ string: Substring) {
                let parts = string.split(separator: ":")

                if parts.count == 2 {
                    guard let (_, categoryString, comparatorString, number) = parts[0].wholeMatch(of: #/([xmas])(<|>)(\d+)/#)?.output,
                          let number = Int(number),
                          let destination = Destination(parts[1])
                    else { return nil }

                    let category: KeyPath<Part, Int> = switch categoryString {
                    case "x": \.x
                    case "m": \.m
                    case "a": \.a
                    case "s": \.s
                    default: fatalError()
                    }

                    let operation: Operation = comparatorString == "<" ? .lessThan : .greaterThan

                    self.condition = (category, number, operation)
                    self.destination = destination
                } else {
                    guard let destination = Destination(parts[0]) else { return nil }
                    self.condition = nil
                    self.destination = destination
                }
            }

            func evaluate(for part: Part) -> Destination? {
                guard let condition else { return destination }

                if condition.operation.evaluate(lhs: part[keyPath: condition.lhs], rhs: condition.rhs) {
                    return destination
                } else {
                    return nil
                }
            }
        }

        var name: String
        var rules: [Rule]

        init?(_ string: Substring) {
            guard let firstCurlyIndex = string.firstIndex(of: "{") else { return nil }
            self.name = String(string.prefix(upTo: firstCurlyIndex))

            let curlyStartIndex = string.index(after: firstCurlyIndex)
            let curlyEndIndex = string.index(before: string.endIndex)
            self.rules = string[curlyStartIndex..<curlyEndIndex]
                .split(separator: ",")
                .compactMap { Rule($0) }
        }
    }

    struct Constraint {
        var moreThan: Int = 0
        var lessThan: Int = 4001

        var acceptedCount: Int {
            if moreThan > lessThan {
                return 0
            }

            return lessThan - moreThan - 1
        }

        func moreThan(_ moreThan: Int) -> Constraint {
            Constraint(moreThan: max(self.moreThan, moreThan), lessThan: lessThan)
        }

        func lessThan(_ lessThan: Int) -> Constraint {
            Constraint(moreThan: moreThan, lessThan: min(self.lessThan, lessThan))
        }
    }
}
