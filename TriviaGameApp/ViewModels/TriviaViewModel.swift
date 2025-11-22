import Foundation

@MainActor
final class TriviaViewModel: ObservableObject {
    // These update the UI automatically
    @Published var options = TriviaOptions()
    @Published var questions: [TriviaQuestion] = []
    @Published var selectedIndices: [UUID: Int] = [:]  // Which answer the user picked
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showScoreAlert = false
    @Published var score = 0
    
    // Called when user taps "Start Game"
    func startGame() async {
        isLoading = true
        errorMessage = nil
        showScoreAlert = false
        score = 0
        selectedIndices = [:]
        
        do {
            // Actually download the questions
            let fetched = try await TriviaAPI.shared.fetchQuestions(options: options)
            questions = fetched
        } catch {
            errorMessage = "Could not load trivia questions."
            questions = []
        }
        
        isLoading = false
    }
    
    // Called when user picks an answer
    func selectAnswer(for question: TriviaQuestion, index: Int) {
        selectedIndices[question.id] = index
    }
    
    // Called when user taps submit
    func submitAnswers() {
        var total = 0
        
        // Count how many answers were correct
        for question in questions {
            if let selected = selectedIndices[question.id],
               selected == question.correctIndex {
                total += 1
            }
        }
        
        score = total
        showScoreAlert = true
    }
    
    // For the alert
    var maxScore: Int {
        questions.count
    }
}
