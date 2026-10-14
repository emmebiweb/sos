import SwiftUI
import AppIntents

/// Deep link che avvia la procedura SOS (usato anche dal vecchio widget: `soshelp://`).
enum SOSLink {
    static let trigger = URL(string: "soshelp://sos")!
}

extension Color {
    static let sosRed = Color(red: 0.929, green: 0.110, blue: 0.141)
    static let sosBright = Color(red: 1.0, green: 0.33, blue: 0.30)
    static let sosDeep = Color(red: 0.62, green: 0.03, blue: 0.08)
}

extension LinearGradient {
    static let sos = LinearGradient(colors: [.sosBright, .sosRed, .sosDeep],
                                    startPoint: .topLeading, endPoint: .bottomTrailing)
}

/// Intent condiviso tra app, Comandi Rapidi, Tasto Azione e Centro di Controllo.
struct TriggerSOSIntent: AppIntent {
    static var title: LocalizedStringResource = "Invia SOS"
    static var description = IntentDescription("Apre SOS e avvia l'invio della tua posizione ai contatti di emergenza.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        SOSIntentBridge.trigger()
        return .result()
    }
}
