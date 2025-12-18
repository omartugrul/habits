//
//  StateColorTestView.swift
//  Habits
//

import SwiftUI

struct StateColorTestView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("State Color Test")
                .font(.largeTitle)
                .padding(.top, 40)

            Text("iOS System Grayscale Palette")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Show all three states
            VStack(spacing: 24) {
                ForEach(HabitState.allCases, id: \.self) { state in
                    StateRow(state: state)
                }
            }
            .padding()

            Spacer()

            Text("Switch between light/dark mode to test")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 20)
        }
    }
}

struct StateRow: View {
    let state: HabitState

    var body: some View {
        HStack(spacing: 16) {
            // Circle filled with state color
            Circle()
                .fill(state.color)
                .frame(width: 60, height: 60)

            // Label and description
            VStack(alignment: .leading, spacing: 4) {
                Text(state.label)
                    .font(.headline)

                Text(colorDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var colorDescription: String {
        switch state {
        case .no:
            return ".primary.opacity(0.2) — Lightest"
        case .kinda:
            return ".secondary — Medium"
        case .yes:
            return ".primary — Strongest"
        }
    }
}

#Preview {
    StateColorTestView()
}
