import EventKit
import Foundation

/// Reads reminders and upcoming calendar events from EventKit.
final class ReminderManager {
    private let store = EKEventStore()

    func requestAccess() async -> Bool {
        let remindersGranted = (try? await store.requestFullAccessToReminders()) ?? false
        let eventsGranted = (try? await store.requestFullAccessToEvents()) ?? false
        return remindersGranted || eventsGranted
    }

    /// The single most urgent thing to surface right now, if any.
    func fetchNextItem() async -> BuddyItem? {
        async let reminder = fetchNextReminder()
        async let event = fetchNextEvent()

        let items = await [reminder, event].compactMap { $0 }
        return items.min { a, b in
            (a.dueDate ?? .distantFuture) < (b.dueDate ?? .distantFuture)
        }
    }

    private func fetchNextReminder() async -> BuddyItem? {
        await withCheckedContinuation { continuation in
            let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
            store.fetchReminders(matching: predicate) { reminders in
                let next = reminders?
                    .compactMap { reminder -> (EKReminder, Date)? in
                        guard let due = reminder.dueDateComponents?.date else { return nil }
                        return (reminder, due)
                    }
                    .sorted { $0.1 < $1.1 }
                    .first

                guard let next else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: BuddyItem(
                    id: next.0.calendarItemIdentifier,
                    kind: .reminder,
                    title: next.0.title ?? "Promemoria",
                    dueDate: next.1
                ))
            }
        }
    }

    private func fetchNextEvent() async -> BuddyItem? {
        let start = Date()
        guard let end = Calendar.current.date(byAdding: .hour, value: 6, to: start) else { return nil }
        let predicate = store.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events = store.events(matching: predicate).sorted { $0.startDate < $1.startDate }

        guard let next = events.first else { return nil }
        return BuddyItem(
            id: next.eventIdentifier,
            kind: .calendarEvent,
            title: next.title ?? "Evento",
            dueDate: next.startDate
        )
    }
}
