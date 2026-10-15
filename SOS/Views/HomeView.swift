import MapKit
import MessageUI
import SwiftUI

struct HomeView: View {
    @Environment(SettingsStore.self) private var store
    @Environment(LocationService.self) private var location
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    @State private var coordinator = SOSCoordinator.shared
    @State private var siren = SirenPlayer()
    @State private var torch = TorchController()
    @State private var camera: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var sheet: HomeSheet?
    @State private var toast: String?

    enum HomeSheet: String, Identifiable {
        case settings, preview
        var id: String { rawValue }
    }

    var body: some View {
        ZStack {
            map

            VStack(spacing: 12) {
                header
                LocationCard()
                Spacer(minLength: 0)
                controlPanel
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            if let toast {
                VStack {
                    Label(toast, systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .padding(.horizontal, 18).padding(.vertical, 12)
                        .glassCard(cornerRadius: 22)
                        .padding(.top, 70)
                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            if coordinator.stage == .countdown {
                CountdownView(
                    seconds: store.prefs.countdownSeconds,
                    recipients: store.prefs.contacts,
                    onCancel: { coordinator.reset() },
                    onFire: fireSOS
                )
                .transition(.opacity.combined(with: .scale(scale: 1.05)))
                .zIndex(10)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: coordinator.stage)
        .animation(.spring, value: toast)
        .onAppear {
            location.start()
            #if DEBUG
            openDebugScreen()
            #endif
        }
        .preferredColorScheme(coordinator.stage == .countdown ? .dark : nil)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { location.start() }
        }
        .sheet(isPresented: composingBinding) { composer }
        .sheet(item: $sheet) { item in
            switch item {
            case .settings: SettingsView()
            case .preview: NavigationStack { MessagePreview() }
            }
        }
    }

    // MARK: - Sezioni

    private var map: some View {
        Map(position: $camera) {
            UserAnnotation()
        }
        .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
        .mapControls { MapCompass() }
        .ignoresSafeArea()
        .overlay(alignment: .top) {
            LinearGradient(colors: [Color(.systemBackground).opacity(0.7), .clear],
                           startPoint: .top, endPoint: .bottom)
                .frame(height: 160)
                .ignoresSafeArea()
                .allowsHitTesting(false)
        }
    }

    private var header: some View {
        HStack(spacing: 10) {
            Image("LogoRed")
                .resizable().scaledToFit()
                .frame(height: 30)
                .accessibilityLabel("SOS")
            Spacer()
            Button {
                withAnimation { camera = .userLocation(fallback: .automatic) }
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .glassCircle()
            }
            .accessibilityLabel("Centra sulla mia posizione")
            Button {
                sheet = .settings
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .glassCircle()
            }
            .accessibilityLabel("Impostazioni")
        }
        .foregroundStyle(.primary)
        .padding(.top, 4)
    }

    private var controlPanel: some View {
        VStack(spacing: 16) {
            SOSButton { coordinator.request() }
                .padding(.top, 22)

            Button { sheet = .settings } label: {
                recipientsSummary
            }
            .buttonStyle(.plain)

            HStack(spacing: 10) {
                ActionTile(title: siren.isPlaying ? "Stop" : "Sirena",
                           systemImage: siren.isPlaying ? "speaker.wave.3.fill" : "megaphone.fill",
                           isActive: siren.isPlaying) { siren.toggle() }
                ActionTile(title: torch.isActive ? "Stop" : "Torcia",
                           systemImage: torch.isActive ? "flashlight.on.fill" : "flashlight.off.fill",
                           isActive: torch.isActive,
                           isEnabled: torch.isAvailable) { torch.toggle() }
                ActionTile(title: "Chiama \(store.prefs.emergencyNumber)",
                           systemImage: "phone.fill") { callEmergency() }
                shareTile
            }
        }
        .padding(14)
        .glassCard(cornerRadius: 32)
    }

    @ViewBuilder
    private var shareTile: some View {
        if let url = location.mapsURL {
            ShareLink(item: url, message: Text("La mia posizione")) {
                ActionTileLabel(title: "Condividi", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(PressableStyle(scale: 0.95))
        } else {
            ActionTile(title: "Condividi", systemImage: "square.and.arrow.up", isEnabled: false) {}
        }
    }

    @ViewBuilder
    private var recipientsSummary: some View {
        let contacts = store.prefs.contacts
        HStack(spacing: 8) {
            if contacts.isEmpty {
                Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(.orange)
                Text("Nessun contatto di emergenza · Aggiungi")
            } else {
                HStack(spacing: -4) {
                    ForEach(contacts.prefix(3)) { c in
                        InitialsAvatar(text: c.initials, size: 32)
                            .overlay(Circle().strokeBorder(Color(.systemBackground), lineWidth: 2))
                    }
                }
                Text(contacts.count == 1 ? "Invia a \(contacts[0].displayName)" : "Invia a \(contacts.count) contatti")
            }
            Image(systemName: "chevron.right").font(.caption.weight(.bold)).foregroundStyle(.tertiary)
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(.secondary)
    }

    // MARK: - Invio

    private var composingBinding: Binding<Bool> {
        Binding(get: { coordinator.stage == .composing },
                set: { if !$0 && coordinator.stage == .composing { coordinator.reset() } })
    }

    private var messageBody: String {
        MessageBuilder.body(prefs: store.prefs, location: location.location, address: location.address)
    }

    @ViewBuilder
    private var composer: some View {
        if MFMessageComposeViewController.canSendText() {
            MessageComposeView(recipients: store.prefs.contacts.map(\.phone), body: messageBody) { result in
                coordinator.reset()
                if result == .sent { showToast("SOS inviato") }
            }
            .ignoresSafeArea()
        } else {
            ShareFallbackView(text: messageBody) { coordinator.reset() }
        }
    }

    private func fireSOS() {
        if store.prefs.autoSiren { siren.play() }
        if store.prefs.autoTorch { torch.start() }
        coordinator.proceed()
    }

    private func callEmergency() {
        let digits = SettingsStore.normalized(store.prefs.emergencyNumber)
        if let url = URL(string: "tel://\(digits)") { openURL(url) }
    }

    #if DEBUG
    /// Screenshot App Store: `-screen settings|preview|countdown|alarm`.
    private func openDebugScreen() {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-screen"), i + 1 < args.count else { return }
        Task {
            try? await Task.sleep(for: .seconds(1.5))
            switch args[i + 1] {
            case "countdown": coordinator.request()
            case "alarm": siren.play(); torch.start()
            case let name: sheet = HomeSheet(rawValue: name)
            }
        }
    }
    #endif

    private func showToast(_ text: String) {
        toast = text
        Task {
            try? await Task.sleep(for: .seconds(2.5))
            toast = nil
        }
    }
}

// MARK: - Card posizione

struct LocationCard: View {
    @Environment(LocationService.self) private var location
    @State private var copied = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle().fill(statusColor.opacity(0.18))
                Image(systemName: location.isDenied ? "location.slash.fill" : "location.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(statusColor)
                    .symbolEffect(.pulse, isActive: location.location == nil && !location.isDenied)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                if location.isDenied {
                    Text("Posizione disattivata").font(.headline)
                    Button("Attivala nelle Impostazioni") { UIApplication.shared.openSettings() }
                        .font(.footnote.weight(.semibold))
                } else {
                    Text(location.address ?? (location.location == nil ? "Ricerca posizione…" : "Posizione trovata"))
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(2)
                        .contentTransition(.opacity)
                    if let coords = location.coordinateText {
                        HStack(spacing: 6) {
                            Text(coords).monospacedDigit()
                            if let acc = location.accuracyText { Text("· \(acc)") }
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                }
            }
            Spacer(minLength: 0)

            if let url = location.mapsURL {
                Menu {
                    Button {
                        UIPasteboard.general.string = location.coordinateText
                        copied = true
                    } label: { Label("Copia coordinate", systemImage: "doc.on.doc") }
                    ShareLink(item: url, message: Text("La mia posizione")) {
                        Label("Condividi posizione", systemImage: "square.and.arrow.up")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 36, height: 36)
                        .background(Color.primary.opacity(0.07), in: .circle)
                }
                .foregroundStyle(.primary)
                .sensoryFeedback(.success, trigger: copied)
            }
        }
        .padding(14)
        .glassCard()
        .animation(.easeInOut, value: location.address)
    }

    private var statusColor: Color {
        if location.isDenied { return .orange }
        return location.location == nil ? .secondary : .green
    }
}

// MARK: - Fallback senza SMS (simulatore, iPad senza SIM)

struct ShareFallbackView: View {
    let text: String
    var onClose: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Label("Questo dispositivo non può inviare SMS. Condividi il messaggio con un'altra app.",
                          systemImage: "exclamationmark.bubble.fill")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Text(text)
                        .font(.callout)
                        .textSelection(.enabled)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground), in: .rect(cornerRadius: 16))
                    ShareLink(item: text) {
                        Label("Condividi messaggio", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()
            }
            .navigationTitle("Invia SOS")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Chiudi") { onClose(); dismiss() }
                }
            }
        }
    }
}
