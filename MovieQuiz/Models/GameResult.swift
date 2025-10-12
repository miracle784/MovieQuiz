import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    func isBetterThan(_ gameResult: GameResult) -> Bool {
         correct > gameResult.correct
    }
}
