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

struct Preferences: Codable {
    var contacts: [EmergencyContact] = []
    var message = Preferences.defaultMessage
    var countdownSeconds = 5
    var autoSiren = false
    var autoTorch = false
    var emergencyNumber = "112"
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
        autoSiren = try c.decodeIfPresent(Bool.self, forKey: .autoSiren) ?? d.autoSiren
        autoTorch = try c.decodeIfPresent(Bool.self, forKey: .autoTorch) ?? d.autoTorch
        emergencyNumber = try c.decodeIfPresent(String.self, forKey: .emergencyNumber) ?? d.emergencyNumber
        hasOnboarded = try c.decodeIfPresent(Bool.self, forKey: .hasOnboarded) ?? d.hasOnboarded
    }
}
