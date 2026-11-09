import Foundation

/// A single thing the buddy might want to tell you about: a due reminder or an upcoming event.
struct BuddyItem: Identifiable, Hashable {
    enum Kind {
        case reminder
        case calendarEvent
    }

    let id: String
    let kind: Kind
    let title: String
    let dueDate: Date?

    /// How urgently this item should be surfaced, used to pick the buddy's mood.
    var mood: BuddyMood {
        guard let dueDate else { return .alert }
        let minutesLeft = dueDate.timeIntervalSinceNow / 60
        if minutesLeft < 0 { return .impatient }
        if minutesLeft < 30 { return .alert }
        return .idle
    }

    var message: String {
        switch kind {
        case .reminder:
            return "Promemoria: \(title)"
        case .calendarEvent:
            return "Tra poco: \(title)"
        }
    }
}
