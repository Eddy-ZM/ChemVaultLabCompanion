import SwiftUI

// MARK: - Main Theatre

struct CinematicMechanismTheatre: View {
    let step: Int
    let animationTrigger: Int

    @State private var phase: MechanismVisualPhase = .reactants

    @State private var attackProgress: CGFloat = 0
    @State private var piProgress: CGFloat = 0
    @State private var workupProgress: CGFloat = 0
    @State private var electronFlowActive = false

    @State private var cameraX: Double = -8
    @State private var cameraY: Double = 0
    @State private var lastCameraX: Double = -8
    @State private var lastCameraY: Double = 0

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isCompact = size.width < 430

            ZStack {
                cinematicStageBackground

                rotatingMechanismScene(size: size, isCompact: isCompact)

                topLeftHUD(isCompact: isCompact)

                bottomHint(isCompact: isCompact)
            }
            .contentShape(Rectangle())
            .gesture(rotationGesture)
            .onAppear {
                phase = visualPhaseFromStep(step)
            }
            .onChange(of: animationTrigger) { _, _ in
                runAnimationForCurrentStep()
            }
        }
    }

    // MARK: - Background

    private var cinematicStageBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.065),
                            Color.white.opacity(0.025),
                            Color.black.opacity(0.16)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.11))
                .frame(width: 275, height: 275)
                .blur(radius: 56)
                .offset(x: -110, y: -70)

            Circle()
                .fill(Color.blue.opacity(0.08))
                .frame(width: 255, height: 255)
                .blur(radius: 60)
                .offset(x: 130, y: 90)

            stageGrid
                .opacity(0.18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
    }

    private var stageGrid: some View {
        Canvas { context, size in
            let spacing: CGFloat = 28

            for x in stride(from: 0, through: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.white.opacity(0.16)), lineWidth: 0.5)
            }

            for y in stride(from: 0, through: size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.white.opacity(0.12)), lineWidth: 0.5)
            }
        }
    }

    // MARK: - Rotating Scene

    private func rotatingMechanismScene(size: CGSize, isCompact: Bool) -> some View {
        ZStack {
            switch phase {
            case .reactants:
                reactantPair(size: size, isCompact: isCompact, approach: 0)
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))

            case .attack:
                reactantPair(size: size, isCompact: isCompact, approach: attackProgress)

                attackArrowLayer(size: size, isCompact: isCompact)
                piArrowLayer(size: size, isCompact: isCompact)

            case .alkoxide:
                AlkoxideMolecule(isCompact: isCompact)
                    .position(x: size.width * 0.50, y: size.height * 0.50)
                    .transition(.opacity.combined(with: .scale(scale: 0.94)))

            case .workup:
                AlkoxideMolecule(isCompact: isCompact)
                    .position(x: size.width * 0.50, y: size.height * 0.50)

                workupArrowLayer(size: size, isCompact: isCompact)

                CinematicAtom(label: "H⁺", role: .hydrogen, size: isCompact ? 30 : 36)
                    .position(
                        x: interpolate(from: size.width * 0.72, to: size.width * 0.56, progress: workupProgress),
                        y: interpolate(from: size.height * 0.22, to: size.height * 0.34, progress: workupProgress)
                    )
                    .shadow(color: .white.opacity(0.65), radius: 12)

            case .product:
                AlcoholProductMolecule(isCompact: isCompact)
                    .position(x: size.width * 0.50, y: size.height * 0.50)
                    .transition(.opacity.combined(with: .scale(scale: 0.94)))
            }
        }
        .rotation3DEffect(
            .degrees(cameraY),
            axis: (x: 0, y: 1, z: 0),
            perspective: 0.72
        )
        .rotation3DEffect(
            .degrees(cameraX),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.72
        )
        .animation(.spring(response: 0.65, dampingFraction: 0.82), value: phase)
    }

    private func reactantPair(size: CGSize, isCompact: Bool, approach: CGFloat) -> some View {
        let leftBaseX = size.width * 0.27
        let rightBaseX = size.width * 0.68
        let y = size.height * 0.50
        let approachShift = size.width * 0.09 * approach

        return ZStack {
            MethylGrignardMolecule(isCompact: isCompact)
                .position(x: leftBaseX + approachShift, y: y)
                .shadow(color: ChemVaultTheme.accent.opacity(0.22), radius: 18)

            Text("+")
                .font(.system(size: isCompact ? 24 : 32, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .position(x: size.width * 0.47, y: y)
                .opacity(1 - Double(approach) * 0.8)

            AcetoneMolecule(isCompact: isCompact)
                .position(x: rightBaseX, y: y)
                .shadow(color: .red.opacity(0.16), radius: 16)
        }
    }

    // MARK: - Arrows

    private func attackArrowLayer(size: CGSize, isCompact: Bool) -> some View {
        let start = CGPoint(x: size.width * 0.31, y: size.height * 0.50)
        let control = CGPoint(x: size.width * 0.46, y: size.height * 0.22)
        let end = CGPoint(x: size.width * 0.65, y: size.height * 0.50)

        return ZStack {
            CinematicCurvedArrow(start: start, control: control, end: end, progress: attackProgress)
                .stroke(
                    ChemVaultTheme.accent,
                    style: StrokeStyle(lineWidth: isCompact ? 4 : 5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.accent.opacity(0.70), radius: 10)

            ElectronStream(
                start: start,
                control: control,
                end: end,
                active: electronFlowActive,
                color: ChemVaultTheme.softAccent
            )
        }
    }

    private func piArrowLayer(size: CGSize, isCompact: Bool) -> some View {
        let start = CGPoint(x: size.width * 0.68, y: size.height * 0.42)
        let control = CGPoint(x: size.width * 0.74, y: size.height * 0.26)
        let end = CGPoint(x: size.width * 0.69, y: size.height * 0.22)

        return ZStack {
            CinematicCurvedArrow(start: start, control: control, end: end, progress: piProgress)
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: isCompact ? 3.5 : 4.5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.softAccent.opacity(0.60), radius: 8)
        }
    }

    private func workupArrowLayer(size: CGSize, isCompact: Bool) -> some View {
        let start = CGPoint(x: size.width * 0.70, y: size.height * 0.24)
        let control = CGPoint(x: size.width * 0.62, y: size.height * 0.18)
        let end = CGPoint(x: size.width * 0.54, y: size.height * 0.34)

        return ZStack {
            CinematicCurvedArrow(start: start, control: control, end: end, progress: workupProgress)
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: isCompact ? 3.5 : 4.5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.softAccent.opacity(0.55), radius: 8)
        }
    }

    // MARK: - HUD

    private func topLeftHUD(isCompact: Bool) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(phaseTitle)
                .font(isCompact ? .caption.bold() : .subheadline.bold())
                .foregroundStyle(ChemVaultTheme.text)

            Text("Camera \(Int(cameraY))°")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(.white.opacity(0.075))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(.white.opacity(0.09), lineWidth: 1)
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(12)
    }

    private func bottomHint(isCompact: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "hand.draw")
            Text("Drag to rotate the mechanism")
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(ChemVaultTheme.secondaryText)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.white.opacity(0.065))
        .clipShape(Capsule())
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 12)
    }

    private var phaseTitle: String {
        switch phase {
        case .reactants:
            return "Reactants aligned"
        case .attack:
            return "Electron flow in progress"
        case .alkoxide:
            return "Tetrahedral alkoxide"
        case .workup:
            return "Proton transfer"
        case .product:
            return "Alcohol product"
        }
    }

    // MARK: - Gesture

    private var rotationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                cameraY = lastCameraY + Double(value.translation.width) * 0.28
                cameraX = lastCameraX - Double(value.translation.height) * 0.18
                cameraX = min(18, max(-24, cameraX))
            }
            .onEnded { _ in
                lastCameraY = cameraY
                lastCameraX = cameraX
            }
    }

    // MARK: - Animation

    private func runAnimationForCurrentStep() {
        if step == 1 {
            phase = .attack
            attackProgress = 0
            piProgress = 0
            electronFlowActive = false

            withAnimation(.easeInOut(duration: 1.05)) {
                attackProgress = 1
                cameraY = -16
                cameraX = -10
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                electronFlowActive = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                withAnimation(.easeInOut(duration: 0.80)) {
                    piProgress = 1
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.25) {
                withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
                    phase = .alkoxide
                    cameraY = 18
                    cameraX = -12
                }
                lastCameraY = cameraY
                lastCameraX = cameraX
            }
        } else if step == 2 {
            phase = .workup
            workupProgress = 0

            withAnimation(.easeInOut(duration: 0.95)) {
                workupProgress = 1
                cameraY = -22
                cameraX = -8
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.02) {
                withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
                    phase = .product
                    cameraY = 12
                    cameraX = -10
                }
                lastCameraY = cameraY
                lastCameraX = cameraX
            }
        } else {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.84)) {
                phase = .reactants
                attackProgress = 0
                piProgress = 0
                workupProgress = 0
                cameraX = -8
                cameraY = 0
            }
            lastCameraX = cameraX
            lastCameraY = cameraY
        }
    }

    private func visualPhaseFromStep(_ step: Int) -> MechanismVisualPhase {
        if step == 0 {
            return .reactants
        } else if step == 1 {
            return .alkoxide
        } else {
            return .product
        }
    }

    private func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
        from + (to - from) * progress
    }
}

// MARK: - Visual Phase

enum MechanismVisualPhase {
    case reactants
    case attack
    case alkoxide
    case workup
    case product
}

// MARK: - Molecules

struct MethylGrignardMolecule: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.78 : 1.0

        ZStack {
            OrbitalLobe(color: ChemVaultTheme.accent.opacity(0.32))
                .frame(width: 86 * s, height: 48 * s)
                .rotationEffect(.degrees(-8))
                .position(x: 43 * s, y: 56 * s)

            CinematicBond(length: 78 * s, angle: 0)
                .position(x: 82 * s, y: 60 * s)

            CinematicBond(length: 48 * s, angle: 30)
                .position(x: 135 * s, y: 74 * s)

            CinematicAtom(label: "CH₃", role: .nucleophile, size: 50 * s)
                .position(x: 42 * s, y: 60 * s)

            CinematicAtom(label: "Mg", role: .metal, size: 46 * s)
                .position(x: 122 * s, y: 60 * s)

            CinematicAtom(label: "Br", role: .bromide, size: 38 * s)
                .position(x: 170 * s, y: 88 * s)

            CinematicChargeBadge("δ−", color: ChemVaultTheme.accent)
                .position(x: 42 * s, y: 18 * s)
        }
        .frame(width: 200 * s, height: 126 * s)
    }
}

struct AcetoneMolecule: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.78 : 1.0

        ZStack {
            PiCloud()
                .frame(width: 70 * s, height: 104 * s)
                .position(x: 105 * s, y: 54 * s)

            CinematicDoubleBond(length: 78 * s, angle: -90)
                .position(x: 105 * s, y: 62 * s)

            CinematicBond(length: 72 * s, angle: -28)
                .position(x: 72 * s, y: 94 * s)

            CinematicBond(length: 72 * s, angle: 28)
                .position(x: 138 * s, y: 94 * s)

            CinematicAtom(label: "O", role: .oxygen, size: 46 * s)
                .position(x: 105 * s, y: 20 * s)

            CinematicAtom(label: "C", role: .carbon, size: 44 * s)
                .position(x: 105 * s, y: 92 * s)

            MethylGroup()
                .scaleEffect(s)
                .position(x: 35 * s, y: 130 * s)

            MethylGroup()
                .scaleEffect(s)
                .position(x: 175 * s, y: 130 * s)

            CinematicChargeBadge("δ+", color: .red.opacity(0.95))
                .position(x: 145 * s, y: 86 * s)

            CinematicChargeBadge("δ−", color: ChemVaultTheme.softAccent)
                .position(x: 105 * s, y: -16 * s)
        }
        .frame(width: 220 * s, height: 170 * s)
    }
}

struct AlkoxideMolecule: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.82 : 1.0

        ZStack {
            GlowRing2(color: .red.opacity(0.42))
                .frame(width: 86 * s, height: 86 * s)
                .position(x: 130 * s, y: 44 * s)

            CinematicBond(length: 78 * s, angle: -90)
                .position(x: 130 * s, y: 82 * s)

            CinematicBond(length: 78 * s, angle: -28)
                .position(x: 94 * s, y: 120 * s)

            CinematicBond(length: 78 * s, angle: 28)
                .position(x: 166 * s, y: 120 * s)

            CinematicBond(length: 82 * s, angle: 90)
                .position(x: 130 * s, y: 154 * s)
                .foregroundStyle(ChemVaultTheme.accent)

            CinematicAtom(label: "O⁻", role: .oxygenCharged, size: 50 * s)
                .position(x: 130 * s, y: 42 * s)

            CinematicAtom(label: "C", role: .carbon, size: 48 * s)
                .position(x: 130 * s, y: 122 * s)

            MethylGroup()
                .scaleEffect(s)
                .position(x: 54 * s, y: 160 * s)

            MethylGroup()
                .scaleEffect(s)
                .position(x: 206 * s, y: 160 * s)

            MethylGroup(color: ChemVaultTheme.accent)
                .scaleEffect(s)
                .position(x: 130 * s, y: 226 * s)

            LonePairDots2()
                .position(x: 168 * s, y: 28 * s)
        }
        .frame(width: 270 * s, height: 260 * s)
    }
}

struct AlcoholProductMolecule: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.82 : 1.0

        ZStack {
            GlowRing2(color: ChemVaultTheme.success.opacity(0.40))
                .frame(width: 230 * s, height: 230 * s)
                .position(x: 130 * s, y: 132 * s)

            CinematicBond(length: 78 * s, angle: -90)
                .position(x: 130 * s, y: 82 * s)

            CinematicBond(length: 48 * s, angle: 34)
                .position(x: 158 * s, y: 34 * s)

            CinematicBond(length: 78 * s, angle: -28)
                .position(x: 94 * s, y: 120 * s)

            CinematicBond(length: 78 * s, angle: 28)
                .position(x: 166 * s, y: 120 * s)

            CinematicBond(length: 82 * s, angle: 90)
                .position(x: 130 * s, y: 154 * s)

            CinematicAtom(label: "O", role: .oxygen, size: 50 * s)
                .position(x: 130 * s, y: 42 * s)

            CinematicAtom(label: "H", role: .hydrogen, size: 34 * s)
                .position(x: 182 * s, y: 20 * s)

            CinematicAtom(label: "C", role: .carbon, size: 48 * s)
                .position(x: 130 * s, y: 122 * s)

            MethylGroup()
                .scaleEffect(s)
                .position(x: 54 * s, y: 160 * s)

            MethylGroup()
                .scaleEffect(s)
                .position(x: 206 * s, y: 160 * s)

            MethylGroup(color: ChemVaultTheme.accent)
                .scaleEffect(s)
                .position(x: 130 * s, y: 226 * s)
        }
        .frame(width: 270 * s, height: 260 * s)
    }
}

// MARK: - Drawing Components

struct CinematicAtom: View {
    enum Role {
        case carbon
        case oxygen
        case oxygenCharged
        case nucleophile
        case metal
        case bromide
        case hydrogen
    }

    let label: String
    let role: Role
    let size: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(atomGradient)

            Circle()
                .stroke(.white.opacity(0.38), lineWidth: 1)

            Circle()
                .fill(.white.opacity(0.20))
                .frame(width: size * 0.36, height: size * 0.22)
                .offset(x: -size * 0.12, y: -size * 0.16)
                .blur(radius: 1)

            Text(label)
                .font(.system(size: max(9, size * 0.26), weight: .bold, design: .rounded))
                .foregroundStyle(role == .hydrogen ? .black.opacity(0.72) : .white)
                .minimumScaleFactor(0.55)
        }
        .frame(width: size, height: size)
        .shadow(color: glowColor, radius: 12)
    }

    private var atomGradient: RadialGradient {
        RadialGradient(
            colors: [
                .white.opacity(0.35),
                baseColor,
                baseColor.opacity(0.72)
            ],
            center: .topLeading,
            startRadius: 2,
            endRadius: size
        )
    }

    private var baseColor: Color {
        switch role {
        case .carbon:
            return Color(red: 0.17, green: 0.19, blue: 0.23)
        case .oxygen:
            return Color(red: 0.95, green: 0.18, blue: 0.18)
        case .oxygenCharged:
            return Color(red: 1.00, green: 0.18, blue: 0.14)
        case .nucleophile:
            return ChemVaultTheme.accent
        case .metal:
            return Color(red: 0.35, green: 0.56, blue: 1.00)
        case .bromide:
            return Color(red: 0.24, green: 0.78, blue: 0.42)
        case .hydrogen:
            return .white
        }
    }

    private var glowColor: Color {
        switch role {
        case .oxygenCharged:
            return .red.opacity(0.55)
        case .nucleophile:
            return ChemVaultTheme.accent.opacity(0.55)
        case .oxygen:
            return .red.opacity(0.25)
        default:
            return .black.opacity(0.28)
        }
    }
}

struct CinematicBond: View {
    let length: CGFloat
    let angle: Double

    var body: some View {
        Capsule()
            .fill(
                LinearGradient(
                    colors: [
                        .white.opacity(0.90),
                        .white.opacity(0.42)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: length, height: 4)
            .rotationEffect(.degrees(angle))
            .shadow(color: .white.opacity(0.10), radius: 3)
    }
}

struct CinematicDoubleBond: View {
    let length: CGFloat
    let angle: Double

    var body: some View {
        ZStack {
            CinematicBond(length: length, angle: 0)
                .offset(y: -4)
            CinematicBond(length: length, angle: 0)
                .offset(y: 4)
        }
        .rotationEffect(.degrees(angle))
    }
}

struct MethylGroup: View {
    var color: Color = ChemVaultTheme.text

    var body: some View {
        Text("CH₃")
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
    }
}

struct CinematicChargeBadge: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.28), lineWidth: 1)
            )
    }
}

struct OrbitalLobe: View {
    let color: Color

    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        color,
                        color.opacity(0.20),
                        .clear
                    ],
                    center: .center,
                    startRadius: 4,
                    endRadius: 60
                )
            )
            .blur(radius: 1)
    }
}

struct PiCloud: View {
    var body: some View {
        ZStack {
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.red.opacity(0.22),
                            Color.red.opacity(0.08),
                            .clear
                        ],
                        center: .center,
                        startRadius: 4,
                        endRadius: 70
                    )
                )
                .offset(x: -12)

            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.red.opacity(0.18),
                            Color.red.opacity(0.06),
                            .clear
                        ],
                        center: .center,
                        startRadius: 4,
                        endRadius: 70
                    )
                )
                .offset(x: 12)
        }
        .blur(radius: 1)
    }
}

struct LonePairDots2: View {
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
        }
        .shadow(color: ChemVaultTheme.softAccent.opacity(0.70), radius: 6)
    }
}

struct GlowRing2: View {
    let color: Color

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 2)
            .blur(radius: 1.2)
            .shadow(color: color, radius: 16)
    }
}

struct CinematicCurvedArrow: Shape {
    let start: CGPoint
    let control: CGPoint
    let end: CGPoint
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let t = min(max(progress, 0), 1)
        let current = pointOnCurve(t: t)

        path.move(to: start)
        path.addQuadCurve(to: current, control: control)

        if t > 0.92 {
            let angle = atan2(current.y - control.y, current.x - control.x)
            let arrowLength: CGFloat = 14
            let arrowAngle: CGFloat = .pi / 6

            let p1 = CGPoint(
                x: current.x - arrowLength * cos(angle - arrowAngle),
                y: current.y - arrowLength * sin(angle - arrowAngle)
            )
            let p2 = CGPoint(
                x: current.x - arrowLength * cos(angle + arrowAngle),
                y: current.y - arrowLength * sin(angle + arrowAngle)
            )

            path.move(to: current)
            path.addLine(to: p1)
            path.move(to: current)
            path.addLine(to: p2)
        }

        return path
    }

    private func pointOnCurve(t: CGFloat) -> CGPoint {
        let x = pow(1 - t, 2) * start.x + 2 * (1 - t) * t * control.x + pow(t, 2) * end.x
        let y = pow(1 - t, 2) * start.y + 2 * (1 - t) * t * control.y + pow(t, 2) * end.y
        return CGPoint(x: x, y: y)
    }
}

struct ElectronStream: View {
    let start: CGPoint
    let control: CGPoint
    let end: CGPoint
    let active: Bool
    let color: Color

    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                let t = phase - CGFloat(index) * 0.11

                Circle()
                    .fill(color)
                    .frame(width: 7, height: 7)
                    .shadow(color: color.opacity(0.9), radius: 7)
                    .position(point(t: max(0, min(1, t))))
                    .opacity(active && t > 0 && t < 1.08 ? 1 : 0)
            }
        }
        .onChange(of: active) { _, newValue in
            if newValue {
                phase = 0
                withAnimation(.linear(duration: 1.02)) {
                    phase = 1.65
                }
            }
        }
    }

    private func point(t: CGFloat) -> CGPoint {
        let x = pow(1 - t, 2) * start.x + 2 * (1 - t) * t * control.x + pow(t, 2) * end.x
        let y = pow(1 - t, 2) * start.y + 2 * (1 - t) * t * control.y + pow(t, 2) * end.y
        return CGPoint(x: x, y: y)
    }
}
