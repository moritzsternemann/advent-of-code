import RegexBuilder

struct Day04: Solution {
    static let day = 04

    private let cards: [Scratchcard]

    init(input: String) {
        self.cards = input.split(separator: "\n")
            .map(Scratchcard.init)
    }

    func runPartOne() -> Int {
        cards
            .map { card in
                card.playerWinningNumbers.reduce(0) { points, playerNumber in
                    if points == 0 {
                        return 1
                    } else {
                        return points * 2
                    }
                }
            }
            .sum()

    }

    func runPartTwo() -> Int {
        var cardCountsById = cards.reduce(into: [:]) { $0[$1.id] = 1 }
        let maxId = cardCountsById.keys.count

        for card in cards {
            let cardCount = cardCountsById[card.id]!
            let winCount = card.playerWinningNumbers.count
            let startOffset = min(card.id + 1, maxId)
            let endOffset = min(startOffset + winCount, maxId + 1)

            for offset in startOffset..<endOffset {
                cardCountsById[offset]! += cardCount
            }
        }

        return cardCountsById.values
            .sum()
    }
}

extension Day04 {
    struct Scratchcard {
        var id: Int
        var winningNumbers: Set<Int>
        var playerNumbers: Set<Int>

        init(_ string: Substring) {
            let colonSeparted = string.split(separator: ": ")
            self.id = Int(colonSeparted[0].replacingOccurrences(of: "Card", with: "").trimmingCharacters(in: .whitespaces))!

            let winningAndPlayer = colonSeparted[1].split(separator: " | ")
            self.winningNumbers = Self.parseNumbers(from: winningAndPlayer[0])
            self.playerNumbers = Self.parseNumbers(from: winningAndPlayer[1])
        }

        private static func parseNumbers(from string: Substring) -> Set<Int> {
            Set(
                string.split(separator: " ")
                    .compactMap {
                        Int($0.trimmingCharacters(in: .whitespaces))
                    }
            )
        }

        var playerWinningNumbers: Set<Int> {
            playerNumbers.intersection(winningNumbers)
        }
    }
}
