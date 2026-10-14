import SwiftUI

/// Scheda leggibile da mostrare ai soccorritori.
struct MedicalCardView: View {
    @Environment(SettingsStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        let medical = store.prefs.medical
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        Image(systemName: "cross.case.fill")
                            .font(.system(size: 34, weight: .semibold))
                        Text(medical.fullName.isEmpty ? "Scheda medica" : medical.fullName)
                            .font(.title.weight(.bold))
                            .multilineTextAlignment(.center)
                        if let birth = medical.birthDate {
                            Text(birth.formatted(date: .long, time: .omitted))
                                .font(.subheadline).opacity(0.85)
                        }
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .background(LinearGradient.sos, in: .rect(cornerRadius: 28))

                    if medical.isEmpty {
                        ContentUnavailableView {
                            Label("Scheda vuota", systemImage: "heart.text.square")
                        } description: {
                            Text("Aggiungi gruppo sanguigno, allergie e farmaci: in emergenza possono fare la differenza.")
                        } actions: {
                            NavigationLink("Compila la scheda") { MedicalEditView() }
                                .buttonStyle(.borderedProminent)
                        }
                    } else {
                        if !medical.bloodType.isEmpty {
                            MedicalRow(title: "Gruppo sanguigno", value: medical.bloodType,
                                       systemImage: "drop.fill", large: true)
                        }
                        MedicalRow(title: "Allergie", value: medical.allergies, systemImage: "allergens")
                        MedicalRow(title: "Farmaci", value: medical.medications, systemImage: "pills.fill")
                        MedicalRow(title: "Patologie", value: medical.conditions, systemImage: "heart.text.square.fill")
                        MedicalRow(title: "Note", value: medical.notes, systemImage: "note.text")
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Scheda medica")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Chiudi") { dismiss() } }
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink("Modifica") { MedicalEditView() }
                }
            }
        }
    }
}

private struct MedicalRow: View {
    let title: String
    let value: String
    let systemImage: String
    var large = false

    var body: some View {
        if !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .foregroundStyle(Color.sosRed)
                    .frame(width: 30)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title.uppercased())
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(value)
                        .font(large ? .system(size: 34, weight: .heavy, design: .rounded) : .title3.weight(.medium))
                }
                Spacer(minLength: 0)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: .rect(cornerRadius: 20))
        }
    }
}

struct MedicalEditView: View {
    @Environment(SettingsStore.self) private var store

    var body: some View {
        @Bindable var store = store
        Form {
            Section("Dati personali") {
                TextField("Nome e cognome", text: $store.prefs.medical.fullName)
                    .textContentType(.name)
                Toggle("Data di nascita", isOn: Binding(
                    get: { store.prefs.medical.birthDate != nil },
                    set: { store.prefs.medical.birthDate = $0 ? (store.prefs.medical.birthDate ?? Date(timeIntervalSince1970: 0)) : nil }
                ))
                if let birth = store.prefs.medical.birthDate {
                    DatePicker("Nato/a il", selection: Binding(
                        get: { birth },
                        set: { store.prefs.medical.birthDate = $0 }
                    ), in: ...Date(), displayedComponents: .date)
                }
            }
            Section("Salute") {
                Picker("Gruppo sanguigno", selection: $store.prefs.medical.bloodType) {
                    ForEach(MedicalInfo.bloodTypes, id: \.self) { t in
                        Text(t.isEmpty ? "Non specificato" : t).tag(t)
                    }
                }
                TextField("Allergie", text: $store.prefs.medical.allergies, axis: .vertical)
                TextField("Farmaci assunti", text: $store.prefs.medical.medications, axis: .vertical)
                TextField("Patologie", text: $store.prefs.medical.conditions, axis: .vertical)
                TextField("Altre note", text: $store.prefs.medical.notes, axis: .vertical)
            }
            Section {
                Toggle("Includi nel messaggio SOS", isOn: $store.prefs.includeMedical)
            } footer: {
                Text("I dati restano solo su questo iPhone e vengono inviati soltanto nei messaggi SOS che decidi di mandare.")
            }
        }
        .navigationTitle("Modifica scheda")
        .navigationBarTitleDisplayMode(.inline)
    }
}
