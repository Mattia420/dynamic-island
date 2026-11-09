import ActivityKit
import Foundation

/// Starts, updates and ends the buddy's Live Activity / Dynamic Island presence.
final class BuddyActivityManager {
    private var activity: Activity<BuddyActivityAttributes>?

    var isRunning: Bool { activity != nil }

    func start(mood: BuddyMood, message: String) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }

        let attributes = BuddyActivityAttributes(startedAt: Date())
        let state = BuddyActivityAttributes.ContentState(mood: mood, message: message, updatedAt: Date())

        activity = try? Activity.request(
            attributes: attributes,
            content: .init(state: state, staleDate: nil)
        )
    }

    func update(mood: BuddyMood, message: String) async {
        guard let activity else {
            start(mood: mood, message: message)
            return
        }
        let state = BuddyActivityAttributes.ContentState(mood: mood, message: message, updatedAt: Date())
        await activity.update(.init(state: state, staleDate: nil))
    }

    func end() async {
        guard let activity else { return }
        await activity.end(nil, dismissalPolicy: .immediate)
        self.activity = nil
    }
}
