import SwiftUI

struct ContentView: View {
    // We create the view model here so all screens can use it
    @StateObject private var viewModel = TriviaViewModel()
    
    var body: some View {
        // This is the first screen the user sees
        OptionsView()
            .environmentObject(viewModel)
    }
}

#Preview {
    ContentView()
}
