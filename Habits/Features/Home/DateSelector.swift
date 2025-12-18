//
//  DateSelector.swift
//  Habits
//

import SwiftUI

struct DateSelector: View {
    // Static for now
    let displayDate = "Tues, Dec 16th"

    var body: some View {
        HStack(spacing: 16) {
            // Left arrow
            Button {
                // TODO: Navigate to previous day
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
            }

            // Date display
            Text(displayDate)
                .font(.headline)
                .frame(maxWidth: .infinity)

            // Right arrow
            Button {
                // TODO: Navigate to next day
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DateSelector()
}
