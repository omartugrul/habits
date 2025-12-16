//
//  ContentView.swift
//  Habits
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Welcome to Habits")
                .font(.title)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
