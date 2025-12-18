//
//  HomeView.swift
//  Habits
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            Text("habits")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 32) {
                    // Summary section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("summary")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)

                        SummaryGrid()
                    }

                    // Date selector
                    DateSelector()

                    // Log cards
                    VStack(spacing: 12) {
                        HabitLogCard(habitName: "Habit 1")
                        HabitLogCard(habitName: "Habit 2")
                        HabitLogCard(habitName: "Habit 3")
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
            }
        }
    }
}

#Preview {
    HomeView()
}
