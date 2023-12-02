struct Day02: Solution {
    static let day = 02

    private let games: [Game]

    init(input: String) {
        self.games = input
            .split(separator: "\n")
            .compactMap { Game($0) }
    }

    func runPartOne() -> Int {
        let numRed = 12
        let numGreen = 13
        let numBlue = 14

        var invalidGames: Set<Game> = []
        for game in games {
            for round in game.rounds {
                if round.red > numRed || round.green > numGreen || round.blue > numBlue {
                    invalidGames.insert(game)
                    break
                }
            }
        }

        let validGames = Set(games).subtracting(invalidGames)

        return validGames.sum(by: \.id)
    }

    func runPartTwo() -> Int {
        games
            .map { game in
                let maxRed = game.rounds.map(\.red).max() ?? 1
                let maxGreen = game.rounds.map(\.green).max() ?? 1
                let maxBlue = game.rounds.map(\.blue).max() ?? 1
                return (maxRed * maxGreen * maxBlue)
            }
            .sum()
    }
}

extension Day02 {
    struct Game: Hashable {
        var id: Int
        var rounds: [Round]

        init?(_ string: Substring) {
            let game = string.split(separator: ": ")
            guard let spaceIndex = game[0].firstIndex(of: " "),
                  let id = Int(game[0].suffix(from: spaceIndex).trimmingCharacters(in: .whitespaces))
            else { return nil }
            self.id = id

            self.rounds = game[1]
                .trimmingCharacters(in: .whitespaces)
                .split(separator: "; ")
                .compactMap { Round($0) }
        }
    }

    struct Round: Hashable {
        var red: Int
        var green: Int
        var blue: Int

        init?(_ string: Substring) {
            let cubes = string.split(separator: ", ").map { $0.split(separator: " ") }
            var red = 0, green = 0, blue = 0
            for cube in cubes {
                guard let count = Int(cube[0]) else { continue }
                switch cube[1] {
                case "red":
                    red = count
                case "green":
                    green = count
                case "blue":
                    blue = count
                default:
                    continue
                }
            }
            self.red = red
            self.green = green
            self.blue = blue
        }
    }
}
