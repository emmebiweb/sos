import Foundation
import Observation

@Observable
final class SettingsStore {
    var prefs: Preferences {
        didSet { persist() }
    }

    @ObservationIgnored private let defaults: UserDefaults
    private static let key = "sos.preferences.v2"
    private static let legacyContactsKey = "CONTACT"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: Self.key),
           let saved = try? JSONDecoder().decode(Preferences.self, from: data) {
            prefs = saved
        } else {
            prefs = Self.migrateLegacy(from: defaults)
            persist()
        }
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-demoData") { prefs = Self.demo }
        #endif
    }

    #if DEBUG
    /// Dati fittizi per screenshot App Store (`-demoData` negli argomenti di lancio).
    static var demo: Preferences {
        var p = Preferences()
        p.contacts = [
            EmergencyContact(name: "Giulia Rossi", phone: "+39 333 123 4567"),
            EmergencyContact(name: "Marco Bianchi", phone: "+39 347 765 4321"),
            EmergencyContact(name: "Mamma", phone: "+39 340 555 1212")
        ]
        p.hasOnboarded = !ProcessInfo.processInfo.arguments.contains("-onboarding")
        return p
    }
    #endif

    func addContacts(_ new: [EmergencyContact]) {
        let existing = Set(prefs.contacts.map { Self.normalized($0.phone) })
        prefs.contacts += new.filter { !existing.contains(Self.normalized($0.phone)) }
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(prefs) {
            defaults.set(data, forKey: Self.key)
        }
    }

    static func normalized(_ phone: String) -> String {
        phone.filter { $0.isNumber || $0 == "+" }
    }

    /// La versione 1.x salvava i contatti come "Cognome Nome - numero" sotto la chiave "CONTACT".
    private static func migrateLegacy(from defaults: UserDefaults) -> Preferences {
        var prefs = Preferences()
        guard let legacy = defaults.stringArray(forKey: legacyContactsKey) else { return prefs }
        prefs.contacts = legacy.compactMap { entry in
            let parts = entry.components(separatedBy: " - ")
            guard let phone = parts.last?.trimmingCharacters(in: .whitespaces), !phone.isEmpty else { return nil }
            let name = parts.dropLast().joined(separator: " - ").trimmingCharacters(in: .whitespaces)
            return EmergencyContact(name: name, phone: phone)
        }
        return prefs
    }
}
