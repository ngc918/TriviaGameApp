import SwiftUI

struct QuestionCardView: View {
    let question: TriviaQuestion
    let selectedIndex: Int?
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Show the question text
            Text(question.question)
                .font(.headline)
            
            // Show each answer as a button
            ForEach(question.answers.indices, id: \.self) { index in
                let isSelected = index == selectedIndex
                
                Button {
                    onSelect(index) // User picked this answer
                } label: {
                    HStack {
                        Text(question.answers[index])
                        Spacer()
                        
                        // Show a checkmark if selected
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? .blue : .gray.opacity(0.3), lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 2)
        )
    }
}
