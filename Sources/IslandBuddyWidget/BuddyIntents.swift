import AppIntents
import ActivityKit

/// Marks the current reminder as handled, tappable directly from the Dynamic Island.
struct BuddyMarkDoneIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Segna come fatto"

    func perform() async throws -> some IntentResult {
        for activity in Activity<BuddyActivityAttributes>.activities {
            let newState = BuddyActivityAttributes.ContentState(
                mood: .happy,
                message: "Fatto! Bel lavoro.",
                updatedAt: Date()
            )
            await activity.update(.init(state: newState, staleDate: nil))
        }
        return .result()
    }
}

/// Snoozes the current reminder for a bit, without opening the app.
struct BuddySnoozeIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Rimanda"

    func perform() async throws -> some IntentResult {
        for activity in Activity<BuddyActivityAttributes>.activities {
            let newState = BuddyActivityAttributes.ContentState(
                mood: .idle,
                message: "Ok, te lo ricordo più tardi.",
                updatedAt: Date()
            )
            await activity.update(.init(state: newState, staleDate: nil))
        }
        return .result()
    }
}
