import SwiftUI

extension View {
    /// Liquid Glass su iOS 26+, materiale traslucido sulle versioni precedenti.
    @ViewBuilder
    func glassCard(cornerRadius: CGFloat = 26) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.regularMaterial, in: .rect(cornerRadius: cornerRadius))
                .overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(.white.opacity(0.25), lineWidth: 0.5))
                .shadow(color: .black.opacity(0.12), radius: 18, y: 8)
        }
    }

    @ViewBuilder
    func glassCircle() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.interactive(), in: .circle)
        } else {
            self
                .background(.regularMaterial, in: .circle)
                .shadow(color: .black.opacity(0.12), radius: 10, y: 4)
        }
    }
}

struct PressableStyle: ButtonStyle {
    var scale: CGFloat = 0.94
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct SOSButton: View {
    var action: () -> Void
    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            ZStack {
                ForEach(0..<2, id: \.self) { i in
                    Circle()
                        .fill(Color.sosRed.opacity(0.35))
                        .scaleEffect(pulse ? 1.55 : 1)
                        .opacity(pulse ? 0 : 0.9)
                        .animation(.easeOut(duration: 2.2).repeatForever(autoreverses: false).delay(Double(i) * 1.1),
                                   value: pulse)
                }
                Circle()
                    .fill(RadialGradient(colors: [.sosBright, .sosRed, .sosDeep],
                                         center: UnitPoint(x: 0.35, y: 0.3), startRadius: 4, endRadius: 110))
                    .overlay(Circle().strokeBorder(.white.opacity(0.45), lineWidth: 3))
                    .shadow(color: .sosRed.opacity(0.55), radius: 22, y: 10)
                VStack(spacing: 2) {
                    Text("SOS")
                        .font(.system(size: 50, weight: .black, design: .rounded))
                    Text("TOCCA PER INVIARE")
                        .font(.system(size: 9, weight: .bold, design: .rounded))
                        .tracking(1.2)
                        .opacity(0.85)
                }
                .foregroundStyle(.white)
            }
            .frame(width: 156, height: 156)
        }
        .buttonStyle(PressableStyle())
        .accessibilityLabel("Invia SOS")
        .accessibilityHint("Avvia il conto alla rovescia e invia la tua posizione ai contatti di emergenza")
        .onAppear { pulse = true }
    }
}

struct ActionTile: View {
    let title: String
    let systemImage: String
    var isActive = false
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 7) {
                Image(systemName: systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .symbolEffect(.pulse, isActive: isActive)
                    .frame(height: 24)
                Text(title)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .foregroundStyle(isActive ? Color.white : Color.primary)
            .background {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isActive ? AnyShapeStyle(LinearGradient.sos) : AnyShapeStyle(Color.primary.opacity(0.07)))
            }
        }
        .buttonStyle(PressableStyle(scale: 0.95))
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
        .sensoryFeedback(.impact(weight: .medium), trigger: isActive)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}

struct InitialsAvatar: View {
    let text: String
    var size: CGFloat = 38

    var body: some View {
        Text(text)
            .font(.system(size: size * 0.36, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(LinearGradient.sos, in: .circle)
    }
}
