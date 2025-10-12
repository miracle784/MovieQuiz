import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
}

// или реализуем протокол с помощью расширения
extension StatisticService: StatisticServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            if let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date {
                return GameResult(correct: correct, total: total, date: date)
            } else {
                // Если значение даты ещё не было сохранено, используем текущую дату
                return GameResult(correct: correct, total: total, date: Date())
            }
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
            
        }
    }
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        if totalQuestionsAsked == 0 {
            return 0
        } else {
            let accuracy = Double(totalCorrectAnswers) / Double(totalQuestionsAsked)
            return accuracy * 100
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        totalCorrectAnswers += count
        
        // Обновляем общее количество заданных вопросов
        totalQuestionsAsked += amount
        
        // Обновляем количество сыгранных игр
        gamesCount += 1
        
        let newResult = GameResult(correct: count, total: amount, date: Date())
        if bestGame.correct < newResult.correct {
            // Если новый результат лучше текущего лучшего результата, сохраняем его
            bestGame = newResult
        }
    }
}
