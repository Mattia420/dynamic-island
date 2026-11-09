import SwiftUI

@main
struct IslandBuddyApp: App {
    @StateObject private var coordinator = BuddyCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(coordinator)
                .task {
                    await coordinator.refresh()
                }
        }
    }
}
