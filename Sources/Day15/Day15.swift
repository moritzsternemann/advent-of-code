struct Day15: Solution {
    static let day = 15

    private let initializationSequence: [Substring]

    init(input: String) {
        self.initializationSequence = input.trimmingCharacters(in: .newlines)
            .split(separator: ",")
    }

    func runPartOne() -> Int {
        initializationSequence
            .map { hash($0) }
            .sum()
    }

    func runPartTwo() -> Int {
        var boxes = Array(repeating: Box(), count: 256)
        for instruction in initializationSequence {
            let label = instruction.prefix(while: \.isLetter)
            let boxNumber = hash(label)

            let operation = instruction[instruction.index(instruction.startIndex, offsetBy: label.count)]
            switch operation {
            case "-":
                boxes[boxNumber].removeAll(where: { $0.label == label })
            case "=":
                guard let focalLength = instruction.last?.wholeNumberValue else { fatalError() }
                if let existingLensIndex = boxes[boxNumber].firstIndex(where: { $0.label == label }) {
                    boxes[boxNumber][existingLensIndex].focalLength = focalLength
                } else {
                    boxes[boxNumber].append(Lens(focalLength: focalLength, label: String(label)))
                }
            default:
                fatalError()
            }
        }

        // Calculate total focusing power
        return boxes.enumerated()
            .flatMap { boxNumber, box in
                box.enumerated().map { slotNumber, lens in
                    (boxNumber + 1) * (slotNumber + 1) * lens.focalLength
                }
            }
            .sum()
    }

    private func hash(_ string: Substring) -> Int {
        string.reduce(0) { hash, character in
            guard let asciiValue = character.asciiValue else { fatalError("not an ASCII string") }
            return ((hash + Int(asciiValue)) * 17) % 256
        }
    }
}

extension Day15 {
    typealias Box = Array<Lens>

    struct Lens {
        var focalLength: Int
        var label: String
    }
}
