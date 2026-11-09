import ActivityKit

struct BuddyActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var mood: BuddyMood
        var message: String
        var updatedAt: Date
    }

    var startedAt: Date
}
