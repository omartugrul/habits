//
//  HabitState.swift
//  Habits
//

import SwiftUI

enum HabitState: String, Codable, CaseIterable {
    case no
    case kinda
    case yes

    /// Color for this state using iOS system grayscale palette
    var color: Color {
        switch self {
        case .no:
            return Color.primary.opacity(0.2)  // Lightest - "not done"
        case .kinda:
            return Color.secondary             // Medium - "partial"
        case .yes:
            return Color.primary               // Strongest - "complete"
        }
    }

    /// Display label
    var label: String {
        switch self {
        case .no: return "NO"
        case .kinda: return "KINDA"
        case .yes: return "YES"
        }
    }

    /// Cycle to next state: NO → KINDA → YES → NO
    mutating func cycle() {
        switch self {
        case .no:
            self = .kinda
        case .kinda:
            self = .yes
        case .yes:
            self = .no
        }
    }

    /// Returns the next state without mutating
    func next() -> HabitState {
        var copy = self
        copy.cycle()
        return copy
    }
}
