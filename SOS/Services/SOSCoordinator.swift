import CoreLocation
import Observation

/// Stato del flusso SOS: idle → countdown → composizione messaggio.
@Observable
final class SOSCoordinator {
    static let shared = SOSCoordinator()

    enum Stage { case idle, countdown, composing }

    var stage: Stage = .idle

    func request() {
        if stage == .idle { stage = .countdown }
    }

    func proceed() { stage = .composing }

    func reset() { stage = .idle }
}

enum MessageBuilder {
    static func body(prefs: Preferences, location: CLLocation?, address: String?) -> String {
        var lines: [String] = []
        let message = prefs.message.trimmingCharacters(in: .whitespacesAndNewlines)
        lines.append("🆘 " + (message.isEmpty ? Preferences.defaultMessage : message))
        lines.append("")

        if let c = location?.coordinate {
            let lat = String(format: "%.6f", c.latitude)
            let lng = String(format: "%.6f", c.longitude)
            if let address, !address.isEmpty { lines.append("📍 \(address)") }
            var coords = "Coordinate: \(lat), \(lng)"
            if let acc = location?.horizontalAccuracy, acc >= 0 { coords += " (±\(Int(acc.rounded())) m)" }
            lines.append(coords)
            lines.append("Mappa: https://maps.google.com/?q=\(lat),\(lng)")
        } else {
            lines.append("📍 Posizione non ancora disponibile.")
        }

        if prefs.includeMedical, !prefs.medical.isEmpty {
            lines.append("")
            lines.append("🩺 Scheda medica")
            lines.append(contentsOf: prefs.medical.summaryLines)
        }

        lines.append("")
        lines.append("Inviato con l'app SOS by emmeBiweb")
        return lines.joined(separator: "\n")
    }
}
