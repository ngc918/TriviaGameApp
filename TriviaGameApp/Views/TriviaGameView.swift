import SwiftUI

struct TriviaGameView: View {
    @EnvironmentObject var viewModel: TriviaViewModel
    // This lets us go back to the previous screen (home screen)
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            
            // This scrolls through all the trivia questions
            ScrollView {
                ForEach(viewModel.questions) { question in
                    
                    // Show a card for each question
                    QuestionCardView(
                        question: question,
                        
                        // This shows which answer the user picked (if any)
                        selectedIndex: viewModel.selectedIndices[question.id],
                        
                        // This runs when the user taps an answer
                        onSelect: { index in
                            viewModel.selectAnswer(for: question, index: index)
                        }
                    )
                    .padding()
                }
            }
            
            // Button the user taps when they are done
            Button("Submit Answers") {
                viewModel.submitAnswers()  // Count score and show alert
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        
        // This sets the title at the top
        .navigationTitle("Trivia Game")
        
        // Alert that shows the score
        .alert("Your Score", isPresented: $viewModel.showScoreAlert) {
            
            // Button inside the alert
            Button("OK") {
                dismiss()   // <-- Go back to the home screen
            }
            
        } message: {
            // Text inside the alert
            Text("You scored \(viewModel.score) out of \(viewModel.maxScore).")
        }
    }
}

