import Foundation

final class TriviaAPI {
    static let shared = TriviaAPI()
    private init() {}
    
    // This function downloads trivia questions from the website
    func fetchQuestions(options: TriviaOptions) async throws -> [TriviaQuestion] {
        
        // Build the URL with the user’s selections
        var components = URLComponents(string: "https://opentdb.com/api.php")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "amount", value: String(options.amount))
        ]
        
        if options.category != .any {
            queryItems.append(URLQueryItem(name: "category", value: "\(options.category.rawValue)"))
        }
        
        if options.difficulty != .any {
            queryItems.append(URLQueryItem(name: "difficulty", value: options.difficulty.rawValue))
        }
        
        if options.type != .any {
            queryItems.append(URLQueryItem(name: "type", value: options.type.rawValue))
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else { throw URLError(.badURL) }
        
        // Download data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Convert data → Swift objects
        let decoded = try JSONDecoder().decode(TriviaAPIResponse.self, from: data)
        
        // Convert API format → app format
        return decoded.results.map { dto in
            var allAnswers = dto.incorrect_answers + [dto.correct_answer]
            allAnswers.shuffle()
            
            let correctIndex = allAnswers.firstIndex(of: dto.correct_answer) ?? 0
            
            return TriviaQuestion(
                question: htmlDecoded(dto.question),
                answers: allAnswers.map { htmlDecoded($0) },
                correctIndex: correctIndex
            )
        }
    }
}


/// This helper cleans up weird text from the API like "&quot;" → `"`
private func htmlDecoded(_ text: String) -> String {
    guard let data = text.data(using: .utf8) else { return text }
    
    // Try converting HTML entities into normal characters
    if let attributed = try? NSAttributedString(
        data: data,
        options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ],
        documentAttributes: nil
    ) {
        return attributed.string
    }
    
    // If something fails, just return the original
    return text
}
