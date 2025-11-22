import SwiftUI

struct OptionsView: View {
    @EnvironmentObject var viewModel: TriviaViewModel
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Pick number of questions
                Section("Number of Questions") {
                    Stepper(value: $viewModel.options.amount, in: 1...50) {
                        Text("\(viewModel.options.amount)")
                    }
                }
                
                // Pick category
                Section("Category") {
                    Picker("Category", selection: $viewModel.options.category) {
                        ForEach(TriviaCategory.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                }
                
                // Pick difficulty
                Section("Difficulty") {
                    Picker("Difficulty", selection: $viewModel.options.difficulty) {
                        ForEach(TriviaDifficulty.allCases) { difficulty in
                            Text(difficulty.displayName).tag(difficulty)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Pick type
                Section("Type") {
                    Picker("Type", selection: $viewModel.options.type) {
                        ForEach(TriviaType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                // Start game button
                Section {
                    Button {
                        Task {
                            await viewModel.startGame()
                            if !viewModel.questions.isEmpty {
                                navigateToGame = true
                            }
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView() // Loading spinner
                        } else {
                            Text("Start Trivia Game")
                        }
                    }
                }
            }
            .navigationTitle("Trivia Options")
            .navigationDestination(isPresented: $navigateToGame) {
                TriviaGameView()
            }
        }
    }
}
