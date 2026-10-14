import Foundation

struct EmergencyContact: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    var phone: String

    var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        let letters = parts.compactMap(\.first).map(String.init).joined()
        return letters.isEmpty ? "#" : letters.uppercased()
    }

    var displayName: String { name.isEmpty ? phone : name }
}

struct MedicalInfo: Codable, Hashable {
    var fullName = ""
    var birthDate: Date?
    var bloodType = ""
    var allergies = ""
    var medications = ""
    var conditions = ""
    var notes = ""

    static let bloodTypes = ["", "0+", "0-", "A+", "A-", "B+", "B-", "AB+", "AB-"]

    var isEmpty: Bool {
        [fullName, bloodType, allergies, medications, conditions, notes]
            .allSatisfy { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty } && birthDate == nil
    }

    /// Righe "Etichetta: valore" per i campi compilati.
    var summaryLines: [String] {
        var lines: [String] = []
        func add(_ label: String, _ value: String) {
            let v = value.trimmingCharacters(in: .whitespacesAndNewlines)
            if !v.isEmpty { lines.append("\(label): \(v)") }
        }
        add("Nome", fullName)
        if let birthDate {
            lines.append("Nato/a il: \(birthDate.formatted(date: .long, time: .omitted))")
        }
        add("Gruppo sanguigno", bloodType)
        add("Allergie", allergies)
        add("Farmaci", medications)
        add("Patologie", conditions)
        add("Note", notes)
        return lines
    }
}

struct Preferences: Codable {
    var contacts: [EmergencyContact] = []
    var message = Preferences.defaultMessage
    var countdownSeconds = 5
    var includeMedical = true
    var autoSiren = false
    var autoTorch = false
    var emergencyNumber = "112"
    var medical = MedicalInfo()
    var hasOnboarded = false

    static let defaultMessage = "Sono qui e ho bisogno di aiuto!"
    static let countdownOptions = [0, 3, 5, 10]

    init() {}

    // Decodifica tollerante: i campi aggiunti in futuro non rompono le preferenze salvate.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let d = Preferences()
        contacts = try c.decodeIfPresent([EmergencyContact].self, forKey: .contacts) ?? d.contacts
        message = try c.decodeIfPresent(String.self, forKey: .message) ?? d.message
        countdownSeconds = try c.decodeIfPresent(Int.self, forKey: .countdownSeconds) ?? d.countdownSeconds
        includeMedical = try c.decodeIfPresent(Bool.self, forKey: .includeMedical) ?? d.includeMedical
        autoSiren = try c.decodeIfPresent(Bool.self, forKey: .autoSiren) ?? d.autoSiren
        autoTorch = try c.decodeIfPresent(Bool.self, forKey: .autoTorch) ?? d.autoTorch
        emergencyNumber = try c.decodeIfPresent(String.self, forKey: .emergencyNumber) ?? d.emergencyNumber
        medical = try c.decodeIfPresent(MedicalInfo.self, forKey: .medical) ?? d.medical
        hasOnboarded = try c.decodeIfPresent(Bool.self, forKey: .hasOnboarded) ?? d.hasOnboarded
    }
}
