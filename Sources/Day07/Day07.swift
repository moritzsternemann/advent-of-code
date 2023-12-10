import Foundation

struct Day07: Solution {
    static let day = 07

    private let game: [(hand: Hand, bid: Int)]

    init(input: String) {
        self.game = input.split(separator: "\n")
            .map { $0.split(separator: " ") }
            .compactMap { line in
                let cards = line[0].compactMap(Card.init)
                let bid = Int(line[1])
                return (Hand(cards: cards), bid ?? 0)
            }
    }

    private func gameTotalWinnings(_ game: [(hand: Hand, bid: Int)]) -> Int {
        let handComparator = HandComparator()
        return game.sorted(using: handComparator, by: \.hand)
            .enumerated()
            .map { (index, round) in
                round.bid * (index + 1)
            }
            .sum()
    }

    func runPartOne() -> Int {
        gameTotalWinnings(game)
    }

    func runPartTwo() -> Int {
        gameTotalWinnings(game.map { ($0.withJokers, $1) })
    }
}

extension Day07 {
    struct Card: Comparable, Equatable, Hashable {
        // X is Joker
        private static let values: [Character: Int] = ["X": -1, "2": 0, "3": 1, "4": 2, "5": 3, "6": 4, "7": 5, "8": 6, "9": 7, "T": 8, "J": 9, "Q": 10, "K": 11, "A": 12]
        let rawValue: Character

        init?(_ rawValue: Character) {
            guard Self.values.keys.contains(rawValue) else { return nil }
            self.rawValue = rawValue
        }

        var isJoker: Bool {
            rawValue == "X"
        }

        static func < (lhs: Card, rhs: Card) -> Bool {
            guard let lhsValue = Self.values[lhs.rawValue],
                  let rhsValue = Self.values[rhs.rawValue]
            else { return false }
            return lhsValue < rhsValue
        }
    }

    enum HandType: Comparable {
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind
    }

    struct Hand: CustomStringConvertible {
        let cards: [Card]
        let type: HandType

        init(cards: [Card]) {
            self.cards = cards
            self.type = Self.handType(for: cards)
        }

        private static func handType(for cards: [Card]) -> HandType {
            assert(cards.count == 5)

            let withoutJokers = cards.filter { !$0.isJoker }
            let jokerCount = 5 - withoutJokers.count

            var countsByCard = Array(withoutJokers.reduce(into: [:]) { $0[$1, default: 0] += 1 }.values)

            // Adjust for jokers
            if let maxCardCount = countsByCard.max(),
               let maxCardCountIndex = countsByCard.firstIndex(of: maxCardCount)
            {
                countsByCard[maxCardCountIndex] += jokerCount
            } else {
                // Only jokers
                countsByCard = [5]
            }

            let countsByFrequency = countsByCard.reduce(into: [:]) { $0[$1, default: 0] += 1 }

            if countsByFrequency[5] == 1 {
                return .fiveOfAKind
            } else if countsByFrequency[4] == 1 {
                return .fourOfAKind
            } else if countsByFrequency[3] == 1 {
                if countsByFrequency[2] == 1 {
                    return .fullHouse
                } else {
                    return .threeOfAKind
                }
            } else if countsByFrequency[2] == 2 {
                return .twoPair
            } else if countsByFrequency[2] == 1 {
                return .onePair
            } else {
                return .highCard
            }
        }

        var withJokers: Hand {
            let cards = cards.compactMap { card in
                if card.rawValue == "J" {
                    return Card("X")
                }
                return card
            }
            return Hand(cards: cards)
        }

        var description: String {
            let cards = self.cards.map { "\($0.rawValue)" }.joined()
            return "\(cards): \(type)"
        }
    }

    struct HandComparator: SortComparator {
        private var handTypeComparator: ComparableComparator<HandType>
        private var cardComparator: ComparableComparator<Card>

        var order: SortOrder {
            didSet {
                handTypeComparator.order = order
                cardComparator.order = order
            }
        }

        init(order: SortOrder = .forward) {
            self.handTypeComparator = ComparableComparator(order: order)
            self.cardComparator = ComparableComparator(order: order)
            self.order = order
        }

        func compare(_ lhs: Hand, _ rhs: Hand) -> ComparisonResult {
            if lhs.type != rhs.type {
                return handTypeComparator.compare(lhs.type, rhs.type)
            }

            for (lhsCard, rhsCard) in zip(lhs.cards, rhs.cards) {
                if lhsCard != rhsCard {
                    return cardComparator.compare(lhsCard, rhsCard)
                }
            }

            return .orderedSame
        }
    }
}
