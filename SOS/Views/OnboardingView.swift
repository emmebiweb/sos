import SwiftUI

struct OnboardingView: View {
    @Environment(SettingsStore.self) private var store
    @Environment(LocationService.self) private var location
    @State private var page = 0

    var body: some View {
        ZStack {
            LinearGradient.sos.ignoresSafeArea()
            Circle()
                .fill(.white.opacity(0.08))
                .frame(width: 520)
                .offset(x: 160, y: -320)
                .blur(radius: 2)

            VStack(spacing: 0) {
                TabView(selection: $page) {
                    welcome.tag(0)
                    features.tag(1)
                    setup.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                Button {
                    if page < 2 {
                        withAnimation { page += 1 }
                    } else {
                        store.prefs.hasOnboarded = true
                    }
                } label: {
                    Text(page < 2 ? "Continua" : "Inizia")
                        .font(.headline)
                        .foregroundStyle(Color.sosRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(.white, in: .capsule)
                }
                .buttonStyle(PressableStyle(scale: 0.97))
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
        .foregroundStyle(.white)
    }

    private var welcome: some View {
        VStack(spacing: 28) {
            Spacer()
            Image("Logo")
                .resizable().scaledToFit()
                .frame(width: 200)
                .shadow(color: .black.opacity(0.2), radius: 20, y: 10)
            VStack(spacing: 12) {
                Text("Aiuto in un tocco")
                    .font(.system(size: 34, weight: .heavy, design: .rounded))
                Text("Invia la tua posizione via SMS alle persone di cui ti fidi. Funziona anche senza connessione internet.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .opacity(0.9)
            }
            .padding(.horizontal, 32)
            Spacer()
            Spacer()
        }
    }

    private var features: some View {
        VStack(alignment: .leading, spacing: 22) {
            Spacer()
            Text("Tutto ciò che serve")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
                .padding(.bottom, 6)
            FeatureRow(icon: "timer", title: "Conto alla rovescia", text: "5 secondi per annullare un invio accidentale.")
            FeatureRow(icon: "megaphone.fill", title: "Sirena di allarme", text: "Un suono forte per farti trovare.")
            FeatureRow(icon: "flashlight.on.fill", title: "Torcia SOS", text: "Il flash lampeggia ··· ––– ··· in Morse.")
            FeatureRow(icon: "cross.case.fill", title: "Scheda medica", text: "Gruppo sanguigno, allergie e farmaci nel messaggio.")
            FeatureRow(icon: "bolt.fill", title: "Widget e Tasto Azione", text: "Lancia l'SOS da Home, blocco schermo o Siri.")
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 28)
    }

    private var setup: some View {
        VStack(spacing: 18) {
            Spacer()
            Text("Prepara SOS")
                .font(.system(size: 30, weight: .heavy, design: .rounded))
            Text("Due passaggi e sei pronto.")
                .opacity(0.9)
                .padding(.bottom, 10)

            SetupButton(icon: "location.fill",
                        title: location.isAuthorized ? "Posizione attiva" : "Consenti posizione",
                        done: location.isAuthorized) {
                if location.isDenied { UIApplication.shared.openSettings() } else { location.requestPermission() }
            }
            SetupButton(icon: "person.2.fill",
                        title: store.prefs.contacts.isEmpty ? "Scegli contatti di emergenza"
                                                            : "\(store.prefs.contacts.count) contatti scelti",
                        done: !store.prefs.contacts.isEmpty) {
                ContactPickerPresenter.shared.present { store.addContacts($0) }
            }
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

private struct FeatureRow: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 50, height: 50)
                .background(.white.opacity(0.18), in: .rect(cornerRadius: 15))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(text).font(.subheadline).opacity(0.85)
            }
        }
    }
}

private struct SetupButton: View {
    let icon: String
    let title: String
    let done: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.2), in: .circle)
                Text(title).font(.headline)
                Spacer()
                Image(systemName: done ? "checkmark.circle.fill" : "chevron.right")
                    .font(.title3)
                    .contentTransition(.symbolEffect(.replace))
            }
            .padding(14)
            .background(.white.opacity(done ? 0.22 : 0.12), in: .rect(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(.white.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(PressableStyle(scale: 0.97))
        .sensoryFeedback(.success, trigger: done)
    }
}
