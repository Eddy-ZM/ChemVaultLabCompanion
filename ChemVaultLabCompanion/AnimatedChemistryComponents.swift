import SwiftUI

enum ChemistryMotionPreset: CaseIterable {
    case orbital
    case scanner
    case seal
    case flask
    case unlock
    case gauge

    var duration: Double {
        switch self {
        case .orbital:
            return 1.35
        case .scanner:
            return 0.95
        case .seal:
            return 0.58
        case .flask:
            return 1.10
        case .unlock:
            return 0.72
        case .gauge:
            return 1.20
        }
    }

    var rotationDegrees: Double {
        switch self {
        case .orbital:
            return 360
        case .seal:
            return 8
        default:
            return 0
        }
    }

    var maximumTravel: Double {
        switch self {
        case .scanner:
            return 140
        case .unlock:
            return 80
        case .orbital, .seal, .flask, .gauge:
            return 0
        }
    }

    var repeats: Bool {
        false
    }
}

struct AnimatedAtomBadge: View {
    let size: CGFloat
    let tint: Color
    let symbol: String
    let delay: Double

    @State private var activated = false

    init(
        size: CGFloat,
        tint: Color = ChemVaultTheme.accent,
        symbol: String = "atom",
        delay: Double = 0
    ) {
        self.size = size
        self.tint = tint
        self.symbol = symbol
        self.delay = delay
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(activated ? 0.18 : 0.08))
                .frame(width: size * 0.82, height: size * 0.82)
                .blur(radius: size * 0.05)

            Circle()
                .stroke(tint.opacity(0.26), lineWidth: 1)
                .frame(width: size, height: size)
                .scaleEffect(activated ? 1.04 : 0.94)

            Circle()
                .trim(from: 0.08, to: 0.86)
                .stroke(
                    LinearGradient(
                        colors: [tint.opacity(0.15), tint.opacity(0.62), tint.opacity(0.08)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: max(1, size * 0.018), lineCap: .round)
                )
                .frame(width: size * 1.10, height: size * 1.10)
                .rotationEffect(.degrees(activated ? 24 : -34))

            Image(systemName: symbol)
                .font(.system(size: size * 0.48, weight: .medium))
                .foregroundStyle(tint)
                .rotationEffect(.degrees(activated ? ChemistryMotionPreset.orbital.rotationDegrees : 0))
                .scaleEffect(activated ? 1 : 0.86)
        }
        .frame(width: size * 1.16, height: size * 1.16)
        .onAppear {
            guard !activated else { return }

            withAnimation(.easeOut(duration: ChemistryMotionPreset.orbital.duration).delay(delay)) {
                activated = true
            }
        }
    }
}

struct AnimatedFlaskBadge: View {
    let size: CGFloat
    let tint: Color
    let delay: Double

    @State private var fillProgress: CGFloat = 0.12
    @State private var lifted = false

    init(size: CGFloat, tint: Color = ChemVaultTheme.accent, delay: Double = 0) {
        self.size = size
        self.tint = tint
        self.delay = delay
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(tint.opacity(lifted ? 0.18 : 0.08))
                .frame(width: size * 0.82, height: size * 0.82)
                .blur(radius: size * 0.045)

            Circle()
                .stroke(tint.opacity(0.28), lineWidth: 1)
                .frame(width: size, height: size)
                .scaleEffect(lifted ? 1.04 : 0.94)

            ZStack {
                Image(systemName: "flask")
                    .font(.system(size: size * 0.48, weight: .semibold))
                    .foregroundStyle(tint.opacity(0.45))

                Image(systemName: "flask.fill")
                    .font(.system(size: size * 0.48, weight: .semibold))
                    .foregroundStyle(tint)
                    .mask(
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Rectangle()
                                .frame(height: size * 0.58 * fillProgress)
                        }
                    )

                Image(systemName: "flask")
                    .font(.system(size: size * 0.48, weight: .semibold))
                    .foregroundStyle(tint)
            }
            .offset(y: lifted ? -2 : 6)
        }
        .frame(width: size * 1.16, height: size * 1.16)
        .onAppear {
            guard !lifted else { return }

            withAnimation(.easeOut(duration: ChemistryMotionPreset.flask.duration).delay(delay)) {
                fillProgress = 0.92
                lifted = true
            }
        }
    }
}

struct DiagnosticSeal: View {
    let title: String
    let icon: String
    let tint: Color
    let delay: Double

    @State private var sealed = false

    init(title: String, icon: String, tint: Color, delay: Double = 0) {
        self.title = title
        self.icon = icon
        self.tint = tint
        self.delay = delay
    }

    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.caption.bold())

            Text(title)
                .font(.caption.bold())
        }
        .foregroundStyle(.black)
        .padding(.horizontal, 11)
        .padding(.vertical, 7)
        .background(tint)
        .clipShape(Capsule())
        .shadow(color: tint.opacity(sealed ? 0.28 : 0), radius: 12, x: 0, y: 7)
        .opacity(sealed ? 1 : 0)
        .scaleEffect(sealed ? 1 : 0.72)
        .rotationEffect(.degrees(sealed ? 0 : -ChemistryMotionPreset.seal.rotationDegrees))
        .onAppear {
            guard !sealed else { return }

            withAnimation(.spring(response: ChemistryMotionPreset.seal.duration, dampingFraction: 0.70).delay(delay)) {
                sealed = true
            }
        }
    }
}

struct ProofUnlockBanner: View {
    let title: String
    let detail: String
    let icon: String
    let tint: Color
    let trigger: Int

    @State private var revealed = false

    init(
        title: String,
        detail: String,
        icon: String = "checkmark.seal.fill",
        tint: Color = ChemVaultTheme.softAccent,
        trigger: Int = 0
    ) {
        self.title = title
        self.detail = detail
        self.icon = icon
        self.tint = tint
        self.trigger = trigger
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.18))
                    .frame(width: 34, height: 34)

                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(tint)
            }
            .scaleEffect(revealed ? 1 : 0.78)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(tint)

                Text(detail)
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding(11)
        .background(tint.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(tint.opacity(0.22), lineWidth: 1)
        )
        .opacity(revealed ? 1 : 0)
        .offset(y: revealed ? 0 : 12)
        .scanSweep(active: revealed, tint: tint, cornerRadius: 16)
        .onAppear(perform: runReveal)
        .onChange(of: trigger) { _, _ in
            runReveal()
        }
    }

    private func runReveal() {
        revealed = false

        DispatchQueue.main.async {
            withAnimation(.spring(response: ChemistryMotionPreset.unlock.duration, dampingFraction: 0.76)) {
                revealed = true
            }
        }
    }
}

private struct ScanSweepModifier: ViewModifier {
    let active: Bool
    let tint: Color
    let cornerRadius: CGFloat

    @State private var sweepVisible = false
    @State private var sweepProgress = false

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    if sweepVisible {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .clear,
                                        tint.opacity(0.08),
                                        tint.opacity(0.40),
                                        tint.opacity(0.08),
                                        .clear
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 54, height: proxy.size.height * 1.55)
                            .rotationEffect(.degrees(12))
                            .offset(
                                x: sweepProgress ? proxy.size.width + CGFloat(ChemistryMotionPreset.scanner.maximumTravel) : -CGFloat(ChemistryMotionPreset.scanner.maximumTravel),
                                y: -proxy.size.height * 0.18
                            )
                            .blendMode(.screen)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .allowsHitTesting(false)
            }
            .onAppear {
                if active {
                    runSweep()
                }
            }
            .onChange(of: active) { _, newValue in
                if newValue {
                    runSweep()
                }
            }
    }

    private func runSweep() {
        sweepVisible = true
        sweepProgress = false

        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: ChemistryMotionPreset.scanner.duration)) {
                sweepProgress = true
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + ChemistryMotionPreset.scanner.duration + 0.05) {
            sweepVisible = false
            sweepProgress = false
        }
    }
}

extension View {
    func scanSweep(
        active: Bool = true,
        tint: Color = ChemVaultTheme.accent,
        cornerRadius: CGFloat = 18
    ) -> some View {
        modifier(ScanSweepModifier(active: active, tint: tint, cornerRadius: cornerRadius))
    }
}
