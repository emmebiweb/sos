import AppIntents

enum SOSIntentBridge {
    @MainActor
    static func trigger() {
        SOSCoordinator.shared.request()
    }
}

struct SOSShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: TriggerSOSIntent(),
            phrases: [
                "Invia SOS con \(.applicationName)",
                "Chiedi aiuto con \(.applicationName)",
                "Emergenza \(.applicationName)"
            ],
            shortTitle: "Invia SOS",
            systemImageName: "sos"
        )
    }
}
