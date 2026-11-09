import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var coordinator: BuddyCoordinator

    var body: some View {
        VStack(spacing: 24) {
            Image(coordinator.mood.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .background(
                    Circle()
                        .fill(coordinator.mood.glowColor.opacity(0.3))
                        .blur(radius: 20)
                )

            Text(coordinator.currentItem?.message ?? "Tutto tranquillo, per ora!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            VStack(spacing: 12) {
                Button("Aggiorna") {
                    Task { await coordinator.refresh() }
                }
                .buttonStyle(.borderedProminent)

                if coordinator.currentItem != nil {
                    Button("Segna come fatto") {
                        Task { await coordinator.markDone() }
                    }
                    .buttonStyle(.bordered)
                }

                if coordinator.isActivityRunning {
                    Button("Ferma il companion", role: .destructive) {
                        Task { await coordinator.stop() }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
        .environmentObject(BuddyCoordinator())
}
