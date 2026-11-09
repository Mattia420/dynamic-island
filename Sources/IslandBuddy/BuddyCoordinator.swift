import Foundation

@MainActor
final class BuddyCoordinator: ObservableObject {
    @Published private(set) var currentItem: BuddyItem?
    @Published private(set) var mood: BuddyMood = .idle
    @Published private(set) var isActivityRunning = false

    private let reminderManager = ReminderManager()
    private let activityManager = BuddyActivityManager()

    func refresh() async {
        let granted = await reminderManager.requestAccess()
        guard granted else { return }

        let item = await reminderManager.fetchNextItem()
        currentItem = item
        mood = item?.mood ?? .idle

        await activityManager.update(mood: mood, message: item?.message ?? "Tutto tranquillo, per ora!")
        isActivityRunning = activityManager.isRunning
    }

    func markDone() async {
        mood = .happy
        await activityManager.update(mood: .happy, message: "Fatto! Bel lavoro.")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        await refresh()
    }

    func stop() async {
        await activityManager.end()
        isActivityRunning = false
    }
}
