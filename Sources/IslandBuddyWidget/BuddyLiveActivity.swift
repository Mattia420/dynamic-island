import ActivityKit
import WidgetKit
import SwiftUI

struct BuddyLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BuddyActivityAttributes.self) { context in
            BuddyLockScreenView(state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    BuddyFaceView(mood: context.state.mood, size: 44)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Circle()
                        .fill(context.state.mood.glowColor)
                        .frame(width: 10, height: 10)
                        .padding(.top, 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(context.state.message)
                            .font(.caption)
                            .lineLimit(2)

                        HStack {
                            Button(intent: BuddySnoozeIntent()) {
                                Label("Rimanda", systemImage: "clock")
                            }
                            Button(intent: BuddyMarkDoneIntent()) {
                                Label("Fatto", systemImage: "checkmark")
                            }
                        }
                        .buttonStyle(.bordered)
                        .font(.caption2)
                    }
                    .padding(.horizontal, 4)
                }
            } compactLeading: {
                BuddyFaceView(mood: context.state.mood, size: 22)
            } compactTrailing: {
                Circle()
                    .fill(context.state.mood.glowColor)
                    .frame(width: 8, height: 8)
            } minimal: {
                BuddyFaceView(mood: context.state.mood, size: 20)
            }
            .keylineTint(context.state.mood.glowColor)
        }
    }
}

/// The buddy's face, with a soft colored glow behind it that reflects its mood.
private struct BuddyFaceView: View {
    let mood: BuddyMood
    let size: CGFloat

    var body: some View {
        Image(mood.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(mood.glowColor.opacity(0.35))
                    .blur(radius: size * 0.3)
            )
    }
}

private struct BuddyLockScreenView: View {
    let state: BuddyActivityAttributes.ContentState

    var body: some View {
        HStack(spacing: 12) {
            BuddyFaceView(mood: state.mood, size: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(state.message)
                    .font(.subheadline)
                    .lineLimit(2)

                HStack {
                    Button(intent: BuddySnoozeIntent()) {
                        Label("Rimanda", systemImage: "clock")
                    }
                    Button(intent: BuddyMarkDoneIntent()) {
                        Label("Fatto", systemImage: "checkmark")
                    }
                }
                .buttonStyle(.bordered)
                .font(.caption)
            }
            Spacer()
        }
        .padding()
        .activityBackgroundTint(Color.black.opacity(0.6))
    }
}
