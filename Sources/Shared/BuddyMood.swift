import SwiftUI

enum BuddyMood: String, Codable, CaseIterable {
    case idle
    case alert
    case happy
    case impatient
    case sleepy
    case tapped

    var imageName: String {
        switch self {
        case .idle: return "buddy_idle"
        case .alert: return "buddy_alert"
        case .happy: return "buddy_happy"
        case .impatient: return "buddy_impatient"
        case .sleepy: return "buddy_sleepy"
        case .tapped: return "buddy_tapped"
        }
    }

    var glowColor: Color {
        switch self {
        case .idle: return .gray.opacity(0.4)
        case .alert: return .orange
        case .happy: return .green
        case .impatient: return .red
        case .sleepy: return .indigo
        case .tapped: return .yellow
        }
    }

    var shouldPulse: Bool {
        switch self {
        case .alert, .impatient: return true
        default: return false
        }
    }
}
