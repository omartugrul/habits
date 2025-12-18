//
//  SummaryGrid.swift
//  Habits
//

import SwiftUI

struct SummaryGrid: View {
    // Hardcoded data for now
    let habits = ["Habit 1", "Habit 2", "Habit 3"]
    let daysToShow = 15

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(habits, id: \.self) { habit in
                HabitRow(habitName: habit, dayCount: daysToShow)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct HabitRow: View {
    let habitName: String
    let dayCount: Int

    // Hardcoded states for demo
    let sampleStates: [HabitState] = [
        .no, .no, .no, .no, .no, .no, .no, .no, .no, .no,
        .kinda, .kinda, .yes, .yes, .yes
    ]

    var body: some View {
        HStack(spacing: 8) {
            // Habit name
            Text(habitName)
                .font(.subheadline)
                .frame(width: 70, alignment: .leading)

            // Day cells
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 4) {
                    ForEach(0..<dayCount, id: \.self) { index in
                        DayCell(state: sampleStates[index])
                    }
                }
            }
        }
    }
}

struct DayCell: View {
    let state: HabitState

    var body: some View {
        Rectangle()
            .fill(state.color)
            .frame(width: 16, height: 16)
            .cornerRadius(3)
    }
}

#Preview {
    SummaryGrid()
}
