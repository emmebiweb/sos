import SwiftUI

struct SettingsView: View {
    @Environment(SettingsStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showingManualAdd = false

    var body: some View {
        @Bindable var store = store
        NavigationStack {
            Form {
                Section {
                    ForEach(store.prefs.contacts) { contact in
                        HStack(spacing: 12) {
                            InitialsAvatar(text: contact.initials)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(contact.displayName).font(.body.weight(.medium))
                                Text(contact.phone).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete { store.prefs.contacts.remove(atOffsets: $0) }
                    .onMove { store.prefs.contacts.move(fromOffsets: $0, toOffset: $1) }

                    Button {
                        ContactPickerPresenter.shared.present { store.addContacts($0) }
                    } label: {
                        Label("Aggiungi dalla rubrica", systemImage: "person.crop.circle.badge.plus")
                    }
                    Button {
                        showingManualAdd = true
                    } label: {
                        Label("Inserisci numero", systemImage: "number")
                    }
                } header: {
                    Text("Contatti di emergenza")
                } footer: {
                    Text("Riceveranno un SMS con la tua posizione. L'SMS funziona anche senza connessione internet.")
                }

                Section {
                    TextField("Messaggio", text: $store.prefs.message, axis: .vertical)
                        .lineLimit(2...5)
                    NavigationLink {
                        MessagePreview()
                    } label: {
                        Label("Anteprima messaggio", systemImage: "text.bubble")
                    }
                } header: {
                    Text("Messaggio")
                }

                Section {
                    Picker(selection: $store.prefs.countdownSeconds) {
                        ForEach(Preferences.countdownOptions, id: \.self) { s in
                            Text(s == 0 ? "Nessuno" : "\(s) secondi").tag(s)
                        }
                    } label: {
                        Label("Conto alla rovescia", systemImage: "timer")
                    }
                    Toggle(isOn: $store.prefs.autoSiren) {
                        Label("Avvia sirena con l'SOS", systemImage: "megaphone")
                    }
                    Toggle(isOn: $store.prefs.autoTorch) {
                        Label("Avvia torcia SOS con l'SOS", systemImage: "flashlight.on.fill")
                    }
                } header: {
                    Text("Invio SOS")
                } footer: {
                    Text("Il conto alla rovescia evita invii accidentali: puoi annullare prima che parta il messaggio.")
                }

                Section {
                    HStack {
                        Label("Numero di emergenza", systemImage: "phone")
                        Spacer()
                        TextField("112", text: $store.prefs.emergencyNumber)
                            .keyboardType(.phonePad)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: 90)
                    }
                } header: {
                    Text("Chiamata rapida")
                }

                Section {
                    LabeledContent("Comandi Rapidi e Siri", value: "“Invia SOS con SOS”")
                    Text("Aggiungi il widget SOS alla schermata Home o di blocco, oppure assegna l'azione “Invia SOS” al Tasto Azione da Impostazioni › Tasto Azione › Comando rapido.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } header: {
                    Text("Accesso rapido")
                }

                Section {
                    LabeledContent("Versione", value: Bundle.main.appVersion)
                    Link(destination: URL(string: "https://emmebiweb.com/sos-app-mb")!) {
                        Label("emmeBiweb", systemImage: "globe")
                    }
                } footer: {
                    Text("SOS non sostituisce i servizi di emergenza. In caso di pericolo chiama sempre il \(store.prefs.emergencyNumber).")
                }
            }
            .navigationTitle("Impostazioni")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fine") { dismiss() }.fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingManualAdd) {
                ManualContactView { store.addContacts([$0]) }
            }
        }
    }
}

struct MessagePreview: View {
    @Environment(SettingsStore.self) private var store
    @Environment(LocationService.self) private var location

    var body: some View {
        ScrollView {
            HStack {
                Spacer(minLength: 48)
                Text(MessageBuilder.body(prefs: store.prefs, location: location.location, address: location.address))
                    .font(.callout)
                    .foregroundStyle(.white)
                    .padding(14)
                    .background(Color.green.gradient, in: .rect(cornerRadius: 20))
            }
            .padding()
        }
        .navigationTitle("Anteprima")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ManualContactView: View {
    var onSave: (EmergencyContact) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var phone = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Nome", text: $name)
                    .textContentType(.name)
                TextField("Numero di telefono", text: $phone)
                    .keyboardType(.phonePad)
                    .textContentType(.telephoneNumber)
            }
            .navigationTitle("Nuovo contatto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Annulla") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Aggiungi") {
                        onSave(EmergencyContact(name: name.trimmingCharacters(in: .whitespaces),
                                                phone: phone.trimmingCharacters(in: .whitespaces)))
                        dismiss()
                    }
                    .disabled(SettingsStore.normalized(phone).count < 3)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

extension Bundle {
    var appVersion: String {
        let v = infoDictionary?["CFBundleShortVersionString"] as? String ?? "–"
        let b = infoDictionary?["CFBundleVersion"] as? String ?? "–"
        return "\(v) (\(b))"
    }
}
