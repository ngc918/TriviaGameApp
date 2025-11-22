import Foundation

// This is the response we get back from the API.
struct TriviaAPIResponse: Codable {
    let response_code: Int
    let results: [TriviaQuestionDTO]
}

// This is the raw question format the API gives us.
struct TriviaQuestionDTO: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

// This is the version we actually use in our app.
// It has shuffled answers and an ID.
struct TriviaQuestion: Identifiable {
    let id = UUID()
    let question: String
    let answers: [String]
    let correctIndex: Int
}

// Stores the user's selected settings
struct TriviaOptions {
    var amount: Int = 5
    var category: TriviaCategory = .any
    var difficulty: TriviaDifficulty = .any
    var type: TriviaType = .any
}

// Different categories the user can pick
enum TriviaCategory: Int, CaseIterable, Identifiable {
    case any = 0
    case generalKnowledge = 9
    case film = 11
    case music = 12
    case videoGames = 15
    
    var id: Int { rawValue }
    
    var displayName: String {
        switch self {
        case .any: return "Any Category"
        case .generalKnowledge: return "General Knowledge"
        case .film: return "Film"
        case .music: return "Music"
        case .videoGames: return "Video Games"
        }
    }
}

// Difficulty picker
enum TriviaDifficulty: String, CaseIterable, Identifiable {
    case any = ""
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .any: return "Any Difficulty"
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}

// Question type picker
enum TriviaType: String, CaseIterable, Identifiable {
    case any = ""
    case multiple = "multiple"
    case boolean = "boolean"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .any: return "Any Type"
        case .multiple: return "Multiple Choice"
        case .boolean: return "True / False"
        }
    }
}

