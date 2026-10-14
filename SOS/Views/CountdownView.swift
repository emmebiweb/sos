import SwiftUI

struct CountdownView: View {
    let seconds: Int
    let recipients: [EmergencyContact]
    var onCancel: () -> Void
    var onFire: () -> Void

    @State private var remaining: Int
    @State private var progress: CGFloat = 1

    init(seconds: Int, recipients: [EmergencyContact], onCancel: @escaping () -> Void, onFire: @escaping () -> Void) {
        self.seconds = seconds
        self.recipients = recipients
        self.onCancel = onCancel
        self.onFire = onFire
        _remaining = State(initialValue: seconds)
    }

    var body: some View {
        ZStack {
            LinearGradient.sos.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()
                Text("Invio SOS tra")
                    .font(.title3.weight(.semibold))
                    .opacity(0.9)

                ZStack {
                    Circle().stroke(.white.opacity(0.2), lineWidth: 14)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(.white, style: StrokeStyle(lineWidth: 14, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(remaining)")
                        .font(.system(size: 110, weight: .heavy, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText(countsDown: true))
                }
                .frame(width: 230, height: 230)

                Text(recipientsText)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .opacity(0.9)
                    .padding(.horizontal, 32)

                Spacer()

                VStack(spacing: 12) {
                    Button(action: onFire) {
                        Text("Invia subito")
                            .font(.headline)
                            .foregroundStyle(Color.sosRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white, in: .capsule)
                    }
                    Button(action: onCancel) {
                        Text("Annulla")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(.white.opacity(0.18), in: .capsule)
                            .overlay(Capsule().strokeBorder(.white.opacity(0.5), lineWidth: 1))
                    }
                }
                .buttonStyle(PressableStyle(scale: 0.97))
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
            }
            .foregroundStyle(.white)
        }
        .sensoryFeedback(.impact(weight: .heavy), trigger: remaining)
        .task { await run() }
    }

    private var recipientsText: String {
        switch recipients.count {
        case 0: return "Sceglierai i destinatari nel messaggio"
        case 1: return "a \(recipients[0].displayName)"
        default: return "a \(recipients.count) contatti di emergenza"
        }
    }

    private func run() async {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-freezeCountdown") {
            remaining = 3; progress = 0.6; return
        }
        #endif
        guard seconds > 0 else { onFire(); return }
        withAnimation(.linear(duration: Double(seconds))) { progress = 0 }
        for _ in 0..<seconds {
            try? await Task.sleep(for: .seconds(1))
            if Task.isCancelled { return }
            withAnimation(.snappy) { remaining -= 1 }
        }
        if !Task.isCancelled { onFire() }
    }
}
