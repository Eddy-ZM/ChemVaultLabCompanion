import SwiftUI

enum AcademicMechanismStep: Int, CaseIterable {
    case polarisation = 0
    case coordination = 1
    case addition = 2
    case alkoxide = 3
    case workup = 4

    var title: String {
        switch self {
        case .polarisation:
            return "1. Bond Polarisation"
        case .coordination:
            return "2. Lewis Acid Coordination"
        case .addition:
            return "3. Nucleophilic Addition"
        case .alkoxide:
            return "4. Magnesium Alkoxide"
        case .workup:
            return "5. Acid Workup"
        }
    }

    var subtitle: String {
        switch self {
        case .polarisation:
            return "C–Mg and C=O bonds are strongly polarised."
        case .coordination:
            return "The carbonyl oxygen coordinates to MgBr⁺."
        case .addition:
            return "The methyl group attacks the carbonyl carbon."
        case .alkoxide:
            return "A tetrahedral magnesium alkoxide intermediate forms."
        case .workup:
            return "Protonation gives the tertiary alcohol."
        }
    }

    var orbitalNote: String {
        switch self {
        case .polarisation:
            return "The C–Mg σ bond is polarised toward carbon, giving CH₃ carbanion-like character."
        case .coordination:
            return "MgBr⁺ acts as a Lewis acid. Coordination lowers the carbonyl π* orbital energy."
        case .addition:
            return "The nucleophile HOMO overlaps with the carbonyl π* LUMO, forming a new C–C bond."
        case .alkoxide:
            return "The former carbonyl oxygen bears negative charge and is associated with MgBr⁺."
        case .workup:
            return "Acidic workup converts the magnesium alkoxide into the neutral alcohol."
        }
    }
}

struct AcademicMechanismTheatre: View {
    let stepIndex: Int
    let animationTrigger: Int

    @State private var arrowA: CGFloat = 0
    @State private var arrowB: CGFloat = 0
    @State private var electronFlow = false

    private var step: AcademicMechanismStep {
        AcademicMechanismStep(rawValue: min(max(stepIndex, 0), 4)) ?? .polarisation
    }

    var body: some View {
        GeometryReader { proxy in
            let isCompact = proxy.size.width < 430

            ZStack {
                academicStageBackground

                VStack(spacing: isCompact ? 8 : 14) {
                    compactHeader(isCompact: isCompact)

                    ZStack {
                        schemeForStep(isCompact: isCompact)
                            .transition(.opacity.combined(with: .scale(scale: 0.94)))
                            .scaleEffect(isCompact ? 0.74 : 0.90)

                        arrowLayer(isCompact: isCompact)
                            .scaleEffect(isCompact ? 0.92 : 1.0)
                    }
                    .frame(height: isCompact ? 215 : 300)
                    .clipped()
                    .id(step.rawValue)

                    compactOrbitalPanel(isCompact: isCompact)
                }
                .padding(isCompact ? 10 : 16)
                .padding(isCompact ? 14 : 18)
            }
            .onAppear {
                resetAnimation()
            }
            .onChange(of: animationTrigger) { _, _ in
                runStepAnimation()
            }
            .onChange(of: stepIndex) { _, _ in
                resetAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    runStepAnimation()
                }
            }
        }
    }

    private func compactOrbitalPanel(isCompact: Bool) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "waveform.path.ecg")
                .font(.caption)
                .foregroundStyle(ChemVaultTheme.accent)

            VStack(alignment: .leading, spacing: 3) {
                Text("Electronic explanation")
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.text)

                Text(step.orbitalNote)
                    .font(.caption2)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .lineLimit(isCompact ? 3 : 4)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(9)
        .background(.white.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.07), lineWidth: 1)
        )
    }

    private func compactHeader(isCompact: Bool) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(step.title)
                    .font(isCompact ? .subheadline.bold() : .headline)
                    .foregroundStyle(ChemVaultTheme.text)

                Text(step.subtitle)
                    .font(isCompact ? .caption2 : .caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text("\(step.rawValue + 1)")
                .font(.caption.bold())
                .foregroundStyle(.black)
                .frame(width: 24, height: 24)
                .background(ChemVaultTheme.accent)
                .clipShape(Circle())
        }
    }

    private var academicStageBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.065),
                            Color.white.opacity(0.028),
                            Color.black.opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.10))
                .frame(width: 280, height: 280)
                .blur(radius: 58)
                .offset(x: -120, y: -80)

            Circle()
                .fill(Color.red.opacity(0.055))
                .frame(width: 240, height: 240)
                .blur(radius: 54)
                .offset(x: 120, y: 80)

            AcademicGrid()
                .opacity(0.18)
        }
    }

    private func header(isCompact: Bool) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(step.title)
                    .font(isCompact ? .headline : .title3.bold())
                    .foregroundStyle(ChemVaultTheme.text)

                Text(step.subtitle)
                    .font(isCompact ? .caption : .subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            Text("Academic")
                .font(.caption.bold())
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(ChemVaultTheme.accent)
                .clipShape(Capsule())
        }
    }

    @ViewBuilder
    private func schemeForStep(isCompact: Bool) -> some View {
        switch step {
        case .polarisation:
            PolarisationScheme(isCompact: isCompact)
        case .coordination:
            CoordinationScheme(isCompact: isCompact)
        case .addition:
            AdditionScheme(isCompact: isCompact)
        case .alkoxide:
            AlkoxideAcademicScheme(isCompact: isCompact)
        case .workup:
            WorkupAcademicScheme(isCompact: isCompact)
        }
    }

    @ViewBuilder
    private func arrowLayer(isCompact: Bool) -> some View {
        switch step {
        case .polarisation:
            EmptyView()

        case .coordination:
            AcademicCurvedArrow(
                start: CGPoint(x: isCompact ? 206 : 333, y: isCompact ? 92 : 122),
                control: CGPoint(x: isCompact ? 184 : 300, y: isCompact ? 48 : 62),
                end: CGPoint(x: isCompact ? 144 : 240, y: isCompact ? 85 : 118),
                progress: arrowA
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: isCompact ? 3.2 : 4.2, lineCap: .round, lineJoin: .round)
            )

        case .addition:
            ZStack {
                AcademicCurvedArrow(
                    start: CGPoint(x: isCompact ? 97 : 165, y: isCompact ? 128 : 165),
                    control: CGPoint(x: isCompact ? 150 : 270, y: isCompact ? 48 : 62),
                    end: CGPoint(x: isCompact ? 230 : 397, y: isCompact ? 130 : 172),
                    progress: arrowA
                )
                .stroke(
                    ChemVaultTheme.accent,
                    style: StrokeStyle(lineWidth: isCompact ? 4 : 5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.accent.opacity(0.65), radius: 8)

                ElectronPairStream(
                    start: CGPoint(x: isCompact ? 97 : 165, y: isCompact ? 128 : 165),
                    control: CGPoint(x: isCompact ? 150 : 270, y: isCompact ? 48 : 62),
                    end: CGPoint(x: isCompact ? 230 : 397, y: isCompact ? 130 : 172),
                    active: electronFlow
                )

                AcademicCurvedArrow(
                    start: CGPoint(x: isCompact ? 238 : 410, y: isCompact ? 112 : 150),
                    control: CGPoint(x: isCompact ? 264 : 455, y: isCompact ? 70 : 88),
                    end: CGPoint(x: isCompact ? 241 : 412, y: isCompact ? 48 : 58),
                    progress: arrowB
                )
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: isCompact ? 3.2 : 4.2, lineCap: .round, lineJoin: .round)
                )
            }

        case .alkoxide:
            EmptyView()

        case .workup:
            AcademicCurvedArrow(
                start: CGPoint(x: isCompact ? 248 : 420, y: isCompact ? 62 : 70),
                control: CGPoint(x: isCompact ? 210 : 360, y: isCompact ? 28 : 40),
                end: CGPoint(x: isCompact ? 174 : 315, y: isCompact ? 78 : 94),
                progress: arrowA
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: isCompact ? 3.4 : 4.4, lineCap: .round, lineJoin: .round)
            )
        }
    }

    private func orbitalPanel(isCompact: Bool) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "waveform.path.ecg")
                .foregroundStyle(ChemVaultTheme.accent)

            VStack(alignment: .leading, spacing: 4) {
                Text("Orbital / Electronic Explanation")
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.text)

                Text(step.orbitalNote)
                    .font(isCompact ? .caption2 : .caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(12)
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    private func resetAnimation() {
        arrowA = 0
        arrowB = 0
        electronFlow = false
    }

    private func runStepAnimation() {
        resetAnimation()

        switch step {
        case .polarisation:
            break

        case .coordination:
            withAnimation(.easeInOut(duration: 0.9)) {
                arrowA = 1
            }

        case .addition:
            withAnimation(.easeInOut(duration: 1.05)) {
                arrowA = 1
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                electronFlow = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
                withAnimation(.easeInOut(duration: 0.75)) {
                    arrowB = 1
                }
            }

        case .alkoxide:
            break

        case .workup:
            withAnimation(.easeInOut(duration: 0.85)) {
                arrowA = 1
            }
        }
    }
}

struct AcademicGrid: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 28

            for x in stride(from: CGFloat(0), through: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.white.opacity(0.10)), lineWidth: 0.5)
            }

            for y in stride(from: CGFloat(0), through: size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.white.opacity(0.08)), lineWidth: 0.5)
            }
        }
    }
}

// MARK: - Academic Schemes

struct PolarisationScheme: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.68 : 1.0

        ZStack {
            VStack(spacing: 8) {
                HStack(spacing: isCompact ? 18 : 34) {
                    AcademicMethylMagnesium(isCompact: isCompact, showCharge: true)

                    Text("+")
                        .font(.system(size: isCompact ? 24 : 34, weight: .bold))
                        .foregroundStyle(ChemVaultTheme.secondaryText)

                    AcademicAcetone(isCompact: isCompact, showCharge: true, coordinated: false)
                }

                Text("The two key polarised bonds determine the direction of electron flow.")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                    .padding(.top, 6)
            }
            .scaleEffect(s)
        }
    }
}

struct CoordinationScheme: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.68 : 1.0

        ZStack {
            HStack(spacing: isCompact ? 14 : 26) {
                AcademicMethylMagnesium(isCompact: isCompact, showCharge: true)

                Text("+")
                    .font(.system(size: isCompact ? 22 : 30, weight: .bold))
                    .foregroundStyle(ChemVaultTheme.secondaryText)

                AcademicAcetone(isCompact: isCompact, showCharge: true, coordinated: true)
            }
            .scaleEffect(s)

            Text("O: → MgBr⁺")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.softAccent)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.white.opacity(0.08))
                .clipShape(Capsule())
                .offset(x: isCompact ? 38 : 72, y: isCompact ? -82 : -112)
        }
    }
}

struct AdditionScheme: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.68 : 1.0

        ZStack {
            HStack(spacing: isCompact ? 18 : 32) {
                AcademicMethylMagnesium(isCompact: isCompact, showCharge: true)

                Text("+")
                    .font(.system(size: isCompact ? 22 : 30, weight: .bold))
                    .foregroundStyle(ChemVaultTheme.secondaryText)

                AcademicAcetone(isCompact: isCompact, showCharge: true, coordinated: true)
            }
            .scaleEffect(s)

            Text("C–C bond forming, C=O π bond breaking")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.accent)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.white.opacity(0.08))
                .clipShape(Capsule())
                .offset(y: isCompact ? 100 : 132)
        }
    }
}

struct AlkoxideAcademicScheme: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.86 : 1.0

        ZStack {
            MagnesiumAlkoxide(isCompact: isCompact)
                .scaleEffect(s)

            Text("magnesium alkoxide intermediate")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .offset(y: isCompact ? 108 : 142)
        }
    }
}

struct WorkupAcademicScheme: View {
    let isCompact: Bool

    var body: some View {
        let s: CGFloat = isCompact ? 0.68 : 1.0

        ZStack {
            HStack(spacing: isCompact ? 18 : 36) {
                MagnesiumAlkoxide(isCompact: isCompact)
                    .scaleEffect(0.82)

                Text("+ H₃O⁺")
                    .font(.system(size: isCompact ? 16 : 20, weight: .bold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.softAccent)

                Text("→")
                    .font(.system(size: isCompact ? 24 : 34, weight: .bold))
                    .foregroundStyle(ChemVaultTheme.accent)

                TertiaryAlcohol(isCompact: isCompact)
                    .scaleEffect(0.88)
            }
            .scaleEffect(s)

            Text("alkoxide protonation")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .offset(y: isCompact ? 108 : 142)
        }
    }
}

// MARK: - Molecule Components

struct AcademicMethylMagnesium: View {
    let isCompact: Bool
    let showCharge: Bool

    var body: some View {
        let scale: CGFloat = isCompact ? 0.72 : 1.0

        ZStack {
            AcademicBond(length: 76 * scale, angle: 0)
                .position(x: 88 * scale, y: 54 * scale)

            AcademicAtom("CH₃", role: .nucleophile, size: 48 * scale)
                .position(x: 44 * scale, y: 54 * scale)

            AcademicAtom("MgBr", role: .metal, size: 52 * scale)
                .position(x: 132 * scale, y: 54 * scale)

            if showCharge {
                AcademicCharge("δ−", color: ChemVaultTheme.accent)
                    .position(x: 44 * scale, y: 12 * scale)

                AcademicCharge("δ+", color: ChemVaultTheme.softAccent)
                    .position(x: 132 * scale, y: 12 * scale)
            }

            Text("MeMgBr")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .position(x: 88 * scale, y: 104 * scale)
        }
        .frame(width: 180 * scale, height: 116 * scale)
    }
}

struct AcademicAcetone: View {
    let isCompact: Bool
    let showCharge: Bool
    let coordinated: Bool

    var body: some View {
        let scale: CGFloat = isCompact ? 0.72 : 1.0

        ZStack {
            AcademicBond(length: 72 * scale, angle: -28)
                .position(x: 72 * scale, y: 104 * scale)

            AcademicBond(length: 72 * scale, angle: 28)
                .position(x: 138 * scale, y: 104 * scale)

            AcademicDoubleBond(length: 78 * scale, angle: -90)
                .position(x: 105 * scale, y: 62 * scale)

            AcademicAtom("O", role: .oxygen, size: 44 * scale)
                .position(x: 105 * scale, y: 18 * scale)

            AcademicAtom("C", role: .carbon, size: 42 * scale)
                .position(x: 105 * scale, y: 92 * scale)

            AcademicGroup("CH₃")
                .position(x: 34 * scale, y: 136 * scale)

            AcademicGroup("CH₃")
                .position(x: 176 * scale, y: 136 * scale)

            if showCharge {
                AcademicCharge("δ−", color: ChemVaultTheme.softAccent)
                    .position(x: 105 * scale, y: -18 * scale)

                AcademicCharge("δ+", color: .red.opacity(0.95))
                    .position(x: 146 * scale, y: 84 * scale)
            }

            if coordinated {
                AcademicBond(length: 48 * scale, angle: -20, dashed: true)
                    .foregroundStyle(ChemVaultTheme.softAccent)
                    .position(x: 76 * scale, y: 30 * scale)

                AcademicAtom("MgBr⁺", role: .metal, size: 42 * scale)
                    .position(x: 36 * scale, y: 44 * scale)
            }

            Text("acetone")
                .font(.caption2.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .position(x: 105 * scale, y: 168 * scale)
        }
        .frame(width: 220 * scale, height: 182 * scale)
    }
}

struct MagnesiumAlkoxide: View {
    let isCompact: Bool

    var body: some View {
        let scale: CGFloat = isCompact ? 0.72 : 1.0

        ZStack {
            AcademicBond(length: 74 * scale, angle: -90)
                .position(x: 124 * scale, y: 78 * scale)

            AcademicBond(length: 76 * scale, angle: -28)
                .position(x: 88 * scale, y: 118 * scale)

            AcademicBond(length: 76 * scale, angle: 28)
                .position(x: 160 * scale, y: 118 * scale)

            AcademicBond(length: 82 * scale, angle: 90)
                .position(x: 124 * scale, y: 154 * scale)

            AcademicAtom("O⁻", role: .oxygenCharged, size: 48 * scale)
                .position(x: 124 * scale, y: 38 * scale)

            AcademicAtom("C", role: .carbon, size: 46 * scale)
                .position(x: 124 * scale, y: 118 * scale)

            AcademicGroup("CH₃")
                .position(x: 46 * scale, y: 158 * scale)

            AcademicGroup("CH₃")
                .position(x: 202 * scale, y: 158 * scale)

            AcademicGroup("CH₃", color: ChemVaultTheme.accent)
                .position(x: 124 * scale, y: 224 * scale)

            AcademicBond(length: 56 * scale, angle: -18, dashed: true)
                .foregroundStyle(ChemVaultTheme.softAccent)
                .position(x: 82 * scale, y: 48 * scale)

            AcademicAtom("MgBr⁺", role: .metal, size: 42 * scale)
                .position(x: 40 * scale, y: 62 * scale)

            LonePairDotsAcademic()
                .position(x: 160 * scale, y: 24 * scale)
        }
        .frame(width: 260 * scale, height: 252 * scale)
    }
}

struct TertiaryAlcohol: View {
    let isCompact: Bool

    var body: some View {
        let scale: CGFloat = isCompact ? 0.72 : 1.0

        ZStack {
            AcademicBond(length: 74 * scale, angle: -90)
                .position(x: 124 * scale, y: 78 * scale)

            AcademicBond(length: 46 * scale, angle: 35)
                .position(x: 150 * scale, y: 32 * scale)

            AcademicBond(length: 76 * scale, angle: -28)
                .position(x: 88 * scale, y: 118 * scale)

            AcademicBond(length: 76 * scale, angle: 28)
                .position(x: 160 * scale, y: 118 * scale)

            AcademicBond(length: 82 * scale, angle: 90)
                .position(x: 124 * scale, y: 154 * scale)

            AcademicAtom("O", role: .oxygen, size: 48 * scale)
                .position(x: 124 * scale, y: 38 * scale)

            AcademicAtom("H", role: .hydrogen, size: 34 * scale)
                .position(x: 176 * scale, y: 16 * scale)

            AcademicAtom("C", role: .carbon, size: 46 * scale)
                .position(x: 124 * scale, y: 118 * scale)

            AcademicGroup("CH₃")
                .position(x: 46 * scale, y: 158 * scale)

            AcademicGroup("CH₃")
                .position(x: 202 * scale, y: 158 * scale)

            AcademicGroup("CH₃", color: ChemVaultTheme.accent)
                .position(x: 124 * scale, y: 224 * scale)
        }
        .frame(width: 260 * scale, height: 252 * scale)
    }
}

// MARK: - Academic Drawing Primitives

struct AcademicAtom: View {
    enum Role {
        case carbon
        case oxygen
        case oxygenCharged
        case nucleophile
        case metal
        case hydrogen
    }

    let label: String
    let role: Role
    let size: CGFloat

    init(_ label: String, role: Role, size: CGFloat) {
        self.label = label
        self.role = role
        self.size = size
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(fill)

            Circle()
                .stroke(.white.opacity(0.35), lineWidth: 1)

            Text(label)
                .font(.system(size: max(9, size * 0.27), weight: .bold, design: .rounded))
                .foregroundStyle(role == .hydrogen ? .black.opacity(0.78) : .white)
                .minimumScaleFactor(0.55)
        }
        .frame(width: size, height: size)
        .shadow(color: glow, radius: 8)
    }

    private var fill: RadialGradient {
        RadialGradient(
            colors: [
                .white.opacity(0.26),
                baseColor,
                baseColor.opacity(0.74)
            ],
            center: .topLeading,
            startRadius: 2,
            endRadius: size
        )
    }

    private var baseColor: Color {
        switch role {
        case .carbon:
            return Color(red: 0.18, green: 0.20, blue: 0.24)
        case .oxygen:
            return Color(red: 0.94, green: 0.18, blue: 0.18)
        case .oxygenCharged:
            return Color(red: 1.00, green: 0.17, blue: 0.12)
        case .nucleophile:
            return ChemVaultTheme.accent
        case .metal:
            return Color(red: 0.35, green: 0.56, blue: 1.00)
        case .hydrogen:
            return .white
        }
    }

    private var glow: Color {
        switch role {
        case .oxygenCharged:
            return .red.opacity(0.45)
        case .nucleophile:
            return ChemVaultTheme.accent.opacity(0.45)
        default:
            return .black.opacity(0.25)
        }
    }
}

struct AcademicGroup: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color = ChemVaultTheme.text) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 9)
            .padding(.vertical, 5)
            .background(.white.opacity(0.07))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            )
    }
}

struct AcademicCharge: View {
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
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(color.opacity(0.28), lineWidth: 1)
            )
    }
}

struct AcademicBond: View {
    let length: CGFloat
    let angle: Double
    var dashed: Bool = false

    var body: some View {
        if dashed {
            DashedBond()
                .frame(width: length, height: 3)
                .rotationEffect(.degrees(angle))
        } else {
            Capsule()
                .fill(.white.opacity(0.72))
                .frame(width: length, height: 3)
                .rotationEffect(.degrees(angle))
        }
    }
}

struct DashedBond: View {
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<6, id: \.self) { _ in
                Capsule()
                    .fill(ChemVaultTheme.softAccent.opacity(0.8))
                    .frame(width: 7, height: 3)
            }
        }
    }
}

struct AcademicDoubleBond: View {
    let length: CGFloat
    let angle: Double

    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.72))
                .frame(width: length, height: 2.4)
                .offset(y: -3)

            Capsule()
                .fill(.white.opacity(0.72))
                .frame(width: length, height: 2.4)
                .offset(y: 3)
        }
        .rotationEffect(.degrees(angle))
    }
}

struct LonePairDotsAcademic: View {
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)

            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
        }
        .shadow(color: ChemVaultTheme.softAccent.opacity(0.70), radius: 5)
    }
}

struct AcademicCurvedArrow: Shape {
    let start: CGPoint
    let control: CGPoint
    let end: CGPoint
    var progress: CGFloat

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let t = min(max(progress, 0), 1)
        let current = pointOnCurve(t: t)

        var path = Path()
        path.move(to: start)
        path.addQuadCurve(to: current, control: control)

        if t > 0.92 {
            let angle = atan2(current.y - control.y, current.x - control.x)
            let arrowLength: CGFloat = 13
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

struct ElectronPairStream: View {
    let start: CGPoint
    let control: CGPoint
    let end: CGPoint
    let active: Bool

    @State private var phase: CGFloat = 0

    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                let t = phase - CGFloat(index) * 0.11

                Circle()
                    .fill(ChemVaultTheme.softAccent)
                    .frame(width: 7, height: 7)
                    .shadow(color: ChemVaultTheme.softAccent.opacity(0.9), radius: 6)
                    .position(point(t: max(0, min(1, t))))
                    .opacity(active && t > 0 && t < 1.08 ? 1 : 0)
            }
        }
        .onChange(of: active) { _, newValue in
            if newValue {
                phase = 0
                withAnimation(.linear(duration: 1.0)) {
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
