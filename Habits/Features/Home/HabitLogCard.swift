//
//  HabitLogCard.swift
//  Habits
//

import SwiftUI

struct HabitLogCard: View {
    let habitName: String
    // Static state for now
    @State private var currentState: HabitState = .no

    var body: some View {
        HStack {
            Text(habitName)
                .font(.body)

            Spacer()

            // State indicator (circle for now)
            Circle()
                .fill(currentState.color)
                .frame(width: 32, height: 32)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    VStack(spacing: 12) {
        HabitLogCard(habitName: "Habit 1")
        HabitLogCard(habitName: "Habit 2")
        HabitLogCard(habitName: "Habit 3")
    }
    .padding()
}
