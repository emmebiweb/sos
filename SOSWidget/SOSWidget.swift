import SwiftUI
import WidgetKit
import AppIntents

/// Nell'estensione l'intent apre solo l'app; la logica vive nel target principale.
enum SOSIntentBridge {
    @MainActor static func trigger() {}
}

@main
struct SOSWidgetBundle: WidgetBundle {
    var body: some Widget {
        SOSWidget()
        if #available(iOS 18.0, *) {
            SOSControl()
        }
    }
}

struct SOSEntry: TimelineEntry {
    let date: Date
}

struct SOSProvider: TimelineProvider {
    func placeholder(in context: Context) -> SOSEntry { SOSEntry(date: .now) }
    func getSnapshot(in context: Context, completion: @escaping (SOSEntry) -> Void) { completion(SOSEntry(date: .now)) }
    func getTimeline(in context: Context, completion: @escaping (Timeline<SOSEntry>) -> Void) {
        completion(Timeline(entries: [SOSEntry(date: .now)], policy: .never))
    }
}

struct SOSWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "SOSWidget", provider: SOSProvider()) { _ in
            SOSWidgetView()
        }
        .configurationDisplayName("SOS")
        .description("Invia la tua posizione ai contatti di emergenza con un tocco.")
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline])
    }
}

struct SOSWidgetView: View {
    @Environment(\.widgetFamily) private var family

    var body: some View {
        content
            .widgetURL(SOSLink.trigger)
    }

    @ViewBuilder
    private var content: some View {
        switch family {
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Text("SOS")
                    .font(.system(size: 17, weight: .black, design: .rounded))
            }
            .containerBackground(for: .widget) { Color.clear }
        case .accessoryRectangular:
            HStack(spacing: 8) {
                Image(systemName: "sos.circle.fill")
                    .font(.system(size: 30, weight: .semibold))
                VStack(alignment: .leading, spacing: 0) {
                    Text("SOS").font(.headline.weight(.black))
                    Text("Tocca per chiedere aiuto").font(.caption)
                }
                Spacer(minLength: 0)
            }
            .containerBackground(for: .widget) { Color.clear }
        case .accessoryInline:
            Label("Invia SOS", systemImage: "sos")
                .containerBackground(for: .widget) { Color.clear }
        default:
            VStack(spacing: 10) {
                ZStack {
                    Circle().fill(.white.opacity(0.18)).frame(width: 92, height: 92)
                    Circle().fill(.white).frame(width: 74, height: 74)
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
                    Text("SOS")
                        .font(.system(size: 26, weight: .black, design: .rounded))
                        .foregroundStyle(Color.sosRed)
                }
                Text("Tocca per aiuto")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
            }
            .containerBackground(for: .widget) { LinearGradient.sos }
        }
    }
}

@available(iOS 18.0, *)
struct SOSControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "com.emmebiweb.sosapp.control") {
            ControlWidgetButton(action: TriggerSOSIntent()) {
                Label("SOS", systemImage: "sos")
            }
        }
        .displayName("Invia SOS")
        .description("Avvia l'invio della posizione ai contatti di emergenza.")
    }
}

#Preview(as: .systemSmall) {
    SOSWidget()
} timeline: {
    SOSEntry(date: .now)
}
