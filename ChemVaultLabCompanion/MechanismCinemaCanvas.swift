import SwiftUI

struct MechanismCinemaCanvas: View {
    let step: CinemaStep
    let focusMode: FocusMode
    let animationTrigger: Int

    @State private var appear = false
    @State private var arrowA: CGFloat = 0
    @State private var arrowB: CGFloat = 0
    @State private var electronFlow = false
    @State private var orbitalAlign: CGFloat = 0
    @State private var productReveal: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let compact = size.width < 430

            ZStack {
                cinemaBackground

                moleculeLayer(size: size, compact: compact)
                    .opacity(appear ? 1 : 0)
                    .scaleEffect(appear ? 1 : 0.96)

                focusLayer(size: size, compact: compact)

                annotationLayer(size: size, compact: compact)
            }
            .clipped()
            .onAppear {
                appear = true
                configureInitialState()
            }
            .onChange(of: step.rawValue) { _, _ in
                configureInitialState()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    runAnimation()
                }
            }
            .onChange(of: animationTrigger) { _, _ in
                runAnimation()
            }
        }
    }

    private var cinemaBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.070),
                            Color.white.opacity(0.028),
                            Color.black.opacity(0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.10))
                .frame(width: 300, height: 300)
                .blur(radius: 56)
                .offset(x: -130, y: -90)

            Circle()
                .fill(Color.red.opacity(0.06))
                .frame(width: 250, height: 250)
                .blur(radius: 52)
                .offset(x: 130, y: 100)

            CinemaGrid()
                .opacity(0.16)
        }
    }

    private func moleculeLayer(size: CGSize, compact: Bool) -> some View {
        let positions = CinemaPositions(size: size, compact: compact)

        return ZStack {
            switch step {
            case .electronicPreparation, .lewisAcidActivation, .orbitalAlignment, .electronMovement:
                reactants(positions: positions, compact: compact)

            case .magnesiumAlkoxide:
                magnesiumAlkoxide(positions: positions, compact: compact)
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))

            case .acidicWorkup:
                ZStack {
                    magnesiumAlkoxide(positions: positions, compact: compact)
                        .opacity(1 - productReveal)

                    alcoholProduct(positions: positions, compact: compact)
                        .opacity(productReveal)
                        .scaleEffect(0.96 + 0.04 * productReveal)
                }
            }
        }
        .animation(.spring(response: 0.65, dampingFraction: 0.84), value: step.rawValue)
    }

    private func reactants(positions p: CinemaPositions, compact: Bool) -> some View {
        ZStack {
            bond(p.meCarbon, p.mg, compact: compact)
            bond(p.mg, p.br, compact: compact, opacity: 0.55)
            doubleBond(p.carbonylC, p.oxygen, compact: compact)
            bond(p.carbonylC, p.leftMethyl, compact: compact)
            bond(p.carbonylC, p.rightMethyl, compact: compact)

            if step == .lewisAcidActivation || step == .orbitalAlignment || step == .electronMovement {
                dashedBond(p.oxygen, p.coordinatedMg, compact: compact)
                    .opacity(step == .lewisAcidActivation ? arrowA : 1)
            }

            atom("CH₃", role: .nucleophile, size: compact ? 42 : 52)
                .position(p.meCarbon)

            atom("Mg", role: .metal, size: compact ? 38 : 46)
                .position(p.mg)

            atom("Br", role: .bromide, size: compact ? 34 : 40)
                .position(p.br)

            atom("C", role: .carbon, size: compact ? 38 : 46)
                .position(p.carbonylC)

            atom("O", role: .oxygen, size: compact ? 40 : 48)
                .position(p.oxygen)

            group("CH₃")
                .position(p.leftMethyl)

            group("CH₃")
                .position(p.rightMethyl)

            if step == .lewisAcidActivation || step == .orbitalAlignment || step == .electronMovement {
                atom("MgBr⁺", role: .metal, size: compact ? 38 : 46)
                    .position(p.coordinatedMg)
                    .opacity(step == .lewisAcidActivation ? arrowA : 1)
            }

            if step == .electronicPreparation || focusMode == .charges {
                charge("δ−", color: ChemVaultTheme.accent)
                    .position(x: p.meCarbon.x, y: p.meCarbon.y - (compact ? 34 : 44))

                charge("δ+", color: ChemVaultTheme.softAccent)
                    .position(x: p.mg.x, y: p.mg.y - (compact ? 34 : 44))

                charge("δ+", color: .red.opacity(0.95))
                    .position(x: p.carbonylC.x + (compact ? 34 : 46), y: p.carbonylC.y - 5)

                charge("δ−", color: ChemVaultTheme.softAccent)
                    .position(x: p.oxygen.x, y: p.oxygen.y - (compact ? 34 : 44))
            }
        }
    }

    private func magnesiumAlkoxide(positions p: CinemaPositions, compact: Bool) -> some View {
        ZStack {
            glowRing(color: .red.opacity(0.42))
                .frame(width: compact ? 74 : 90, height: compact ? 74 : 90)
                .position(p.alkoxideO)

            bond(p.alkoxideC, p.alkoxideO, compact: compact)
            bond(p.alkoxideC, p.alkoxideLeft, compact: compact)
            bond(p.alkoxideC, p.alkoxideRight, compact: compact)
            bond(p.alkoxideC, p.alkoxideNewMe, compact: compact, color: ChemVaultTheme.accent)
            dashedBond(p.alkoxideO, p.alkoxideMg, compact: compact)

            atom("O⁻", role: .oxygenCharged, size: compact ? 42 : 52)
                .position(p.alkoxideO)

            atom("C", role: .carbon, size: compact ? 40 : 48)
                .position(p.alkoxideC)

            atom("MgBr⁺", role: .metal, size: compact ? 38 : 46)
                .position(p.alkoxideMg)

            group("CH₃")
                .position(p.alkoxideLeft)

            group("CH₃")
                .position(p.alkoxideRight)

            group("CH₃", color: ChemVaultTheme.accent)
                .position(p.alkoxideNewMe)

            lonePairs()
                .position(x: p.alkoxideO.x + (compact ? 30 : 40), y: p.alkoxideO.y - (compact ? 12 : 16))
        }
    }

    private func alcoholProduct(positions p: CinemaPositions, compact: Bool) -> some View {
        let h = CGPoint(x: p.alkoxideO.x + (compact ? 50 : 64), y: p.alkoxideO.y - (compact ? 24 : 30))

        return ZStack {
            glowRing(color: ChemVaultTheme.success.opacity(0.42))
                .frame(width: compact ? 205 : 250, height: compact ? 205 : 250)
                .position(p.alkoxideC)

            bond(p.alkoxideC, p.alkoxideO, compact: compact)
            bond(p.alkoxideO, h, compact: compact, opacity: 0.8)
            bond(p.alkoxideC, p.alkoxideLeft, compact: compact)
            bond(p.alkoxideC, p.alkoxideRight, compact: compact)
            bond(p.alkoxideC, p.alkoxideNewMe, compact: compact, color: ChemVaultTheme.accent)

            atom("O", role: .oxygen, size: compact ? 42 : 52)
                .position(p.alkoxideO)

            atom("H", role: .hydrogen, size: compact ? 30 : 36)
                .position(h)

            atom("C", role: .carbon, size: compact ? 40 : 48)
                .position(p.alkoxideC)

            group("CH₃")
                .position(p.alkoxideLeft)

            group("CH₃")
                .position(p.alkoxideRight)

            group("CH₃", color: ChemVaultTheme.accent)
                .position(p.alkoxideNewMe)
        }
    }

    @ViewBuilder
    private func focusLayer(size: CGSize, compact: Bool) -> some View {
        let p = CinemaPositions(size: size, compact: compact)

        switch focusMode {
        case .mechanism:
            mechanismFocusOverlay(size: size, compact: compact, positions: p)

        case .orbitals:
            orbitalFocusOverlay(size: size, compact: compact, positions: p)

        case .charges:
            chargeFocusOverlay(size: size, compact: compact, positions: p)

        case .energy:
            energyFocusOverlay(size: size, compact: compact)
        }
    }

    @ViewBuilder
    private func mechanismFocusOverlay(size: CGSize, compact: Bool, positions p: CinemaPositions) -> some View {
        ZStack {
            mechanismArrows(size: size, compact: compact)

            if step == .electronicPreparation {
                FocusHalo(color: ChemVaultTheme.accent)
                    .frame(width: compact ? 72 : 92, height: compact ? 72 : 92)
                    .position(p.meCarbon)

                FocusHalo(color: .red.opacity(0.75))
                    .frame(width: compact ? 72 : 92, height: compact ? 72 : 92)
                    .position(p.carbonylC)
            }

            if step == .magnesiumAlkoxide {
                FocusHalo(color: .red.opacity(0.75))
                    .frame(width: compact ? 82 : 104, height: compact ? 82 : 104)
                    .position(p.alkoxideO)

                LabelChip(text: "O⁻···MgBr⁺")
                    .position(x: p.alkoxideC.x, y: p.alkoxideC.y - size.height * 0.35)
            }
        }
    }

    @ViewBuilder
    private func orbitalFocusOverlay(size: CGSize, compact: Bool, positions p: CinemaPositions) -> some View {
        ZStack {
            if step == .acidicWorkup || step == .magnesiumAlkoxide {
                LabelChip(text: "Orbital interaction already completed")
                    .position(x: size.width * 0.50, y: size.height * 0.18)
            } else {
                OrbitalCloud(color: ChemVaultTheme.accent.opacity(0.38))
                    .frame(width: compact ? 92 : 120, height: compact ? 50 : 64)
                    .rotationEffect(.degrees(-8))
                    .position(p.meCarbon)

                PiStarCloud()
                    .frame(width: compact ? 74 : 92, height: compact ? 112 : 138)
                    .position(x: p.carbonylC.x, y: (p.carbonylC.y + p.oxygen.y) / 2)

                CinemaArrow(
                    start: p.meCarbon,
                    control: CGPoint(x: size.width * 0.47, y: size.height * 0.20),
                    end: p.carbonylC,
                    progress: step == .orbitalAlignment ? orbitalAlign : 1
                )
                .stroke(
                    ChemVaultTheme.accent,
                    style: StrokeStyle(lineWidth: compact ? 3.4 : 4.4, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.accent.opacity(0.55), radius: 8)

                LabelChip(text: "HOMO(C–Mg) → LUMO(π*C=O)")
                    .position(x: size.width * 0.50, y: size.height * 0.16)
            }
        }
    }

    @ViewBuilder
    private func chargeFocusOverlay(size: CGSize, compact: Bool, positions p: CinemaPositions) -> some View {
        ZStack {
            switch step {
            case .electronicPreparation, .lewisAcidActivation, .orbitalAlignment, .electronMovement:
                charge("δ−", color: ChemVaultTheme.accent)
                    .position(x: p.meCarbon.x, y: p.meCarbon.y - (compact ? 36 : 46))

                charge("δ+", color: ChemVaultTheme.softAccent)
                    .position(x: p.mg.x, y: p.mg.y - (compact ? 36 : 46))

                charge("δ+", color: .red.opacity(0.95))
                    .position(x: p.carbonylC.x + (compact ? 34 : 46), y: p.carbonylC.y - 5)

                charge("δ−", color: ChemVaultTheme.softAccent)
                    .position(x: p.oxygen.x, y: p.oxygen.y - (compact ? 36 : 46))

                FocusHalo(color: ChemVaultTheme.accent)
                    .frame(width: compact ? 72 : 92, height: compact ? 72 : 92)
                    .position(p.meCarbon)

                FocusHalo(color: .red.opacity(0.7))
                    .frame(width: compact ? 72 : 92, height: compact ? 72 : 92)
                    .position(p.carbonylC)

            case .magnesiumAlkoxide:
                charge("O⁻", color: .red.opacity(0.95))
                    .position(x: p.alkoxideO.x, y: p.alkoxideO.y - (compact ? 38 : 48))

                charge("MgBr⁺", color: ChemVaultTheme.softAccent)
                    .position(x: p.alkoxideMg.x, y: p.alkoxideMg.y - (compact ? 34 : 44))

                FocusHalo(color: .red.opacity(0.72))
                    .frame(width: compact ? 82 : 104, height: compact ? 82 : 104)
                    .position(p.alkoxideO)

            case .acidicWorkup:
                LabelChip(text: "O⁻ is protonated → neutral OH")
                    .position(x: size.width * 0.50, y: size.height * 0.18)

                FocusHalo(color: ChemVaultTheme.success)
                    .frame(width: compact ? 160 : 210, height: compact ? 160 : 210)
                    .position(p.alkoxideC)
            }
        }
    }

    @ViewBuilder
    private func energyFocusOverlay(size: CGSize, compact: Bool) -> some View {
        ZStack {
            EnergyCinemaOverlay(step: step)
                .frame(width: compact ? size.width * 0.88 : size.width * 0.72,
                       height: compact ? 145 : 170)
                .position(x: size.width * 0.50, y: size.height * 0.73)

            LabelChip(text: energyLabel)
                .position(x: size.width * 0.50, y: size.height * 0.18)
        }
    }

    private var energyLabel: String {
        switch step {
        case .electronicPreparation:
            return "Reactants: polarised but not yet reacted"
        case .lewisAcidActivation:
            return "Lewis acid activation lowers the barrier"
        case .orbitalAlignment:
            return "Orbital alignment prepares the transition state"
        case .electronMovement:
            return "Bond-forming transition state region"
        case .magnesiumAlkoxide:
            return "Magnesium alkoxide intermediate"
        case .acidicWorkup:
            return "Separate proton-transfer workup"
        }
    }

    @ViewBuilder
    private func mechanismArrows(size: CGSize, compact: Bool) -> some View {
        let p = CinemaPositions(size: size, compact: compact)

        if step == .lewisAcidActivation {
            CinemaArrow(
                start: p.oxygen,
                control: CGPoint(x: size.width * 0.61, y: size.height * 0.16),
                end: p.coordinatedMg,
                progress: arrowA
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: compact ? 3.0 : 4.0, lineCap: .round, lineJoin: .round)
            )
        }

        if step == .electronMovement {
            CinemaArrow(
                start: p.meCarbon,
                control: CGPoint(x: size.width * 0.48, y: size.height * 0.18),
                end: p.carbonylC,
                progress: arrowA
            )
            .stroke(
                ChemVaultTheme.accent,
                style: StrokeStyle(lineWidth: compact ? 4.0 : 5.0, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: ChemVaultTheme.accent.opacity(0.7), radius: 9)

            ElectronPairFlight(
                start: p.meCarbon,
                control: CGPoint(x: size.width * 0.48, y: size.height * 0.18),
                end: p.carbonylC,
                active: electronFlow
            )

            CinemaArrow(
                start: CGPoint(x: p.carbonylC.x, y: p.carbonylC.y - 16),
                control: CGPoint(x: size.width * 0.76, y: size.height * 0.23),
                end: p.oxygen,
                progress: arrowB
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: compact ? 3.2 : 4.2, lineCap: .round, lineJoin: .round)
            )
        }

        if step == .acidicWorkup {
            let hStart = CGPoint(x: size.width * 0.75, y: size.height * 0.22)
            let hEnd = CGPoint(x: p.alkoxideO.x + (compact ? 50 : 64), y: p.alkoxideO.y - (compact ? 24 : 30))
            let h = CGPoint(
                x: hStart.x + (hEnd.x - hStart.x) * productReveal,
                y: hStart.y + (hEnd.y - hStart.y) * productReveal
            )

            CinemaArrow(
                start: hStart,
                control: CGPoint(x: size.width * 0.64, y: size.height * 0.14),
                end: hEnd,
                progress: arrowA
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: compact ? 3.4 : 4.4, lineCap: .round, lineJoin: .round)
            )

            atom("H⁺", role: .hydrogen, size: compact ? 30 : 36)
                .position(h)
                .opacity(1 - productReveal)
        }
    }

    private func annotationLayer(size: CGSize, compact: Bool) -> some View {
        VStack {
            HStack {
                MicroPanel(title: step.title, value: step.keyFormula)
                Spacer()
            }
            Spacer()
        }
        .padding(compact ? 10 : 14)
    }

    private func configureInitialState() {
        arrowA = 0
        arrowB = 0
        electronFlow = false
        orbitalAlign = step == .orbitalAlignment ? 0 : 1
        productReveal = step == .acidicWorkup ? 0 : 1
    }

    private func runAnimation() {
        configureInitialState()

        switch step {
        case .electronicPreparation:
            break

        case .lewisAcidActivation:
            withAnimation(.easeInOut(duration: 0.95)) {
                arrowA = 1
            }

        case .orbitalAlignment:
            withAnimation(.easeInOut(duration: 1.1)) {
                orbitalAlign = 1
            }

        case .electronMovement:
            withAnimation(.easeInOut(duration: 1.05)) {
                arrowA = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                electronFlow = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.75)) {
                    arrowB = 1
                }
            }

        case .magnesiumAlkoxide:
            break

        case .acidicWorkup:
            withAnimation(.easeInOut(duration: 0.9)) {
                arrowA = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
                    productReveal = 1
                }
            }
        }
    }

    private func atom(_ label: String, role: CinemaAtom.Role, size: CGFloat) -> some View {
        CinemaAtom(label: label, role: role, size: size)
    }

    private func group(_ label: String, color: Color = ChemVaultTheme.text) -> some View {
        Text(label)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.10), lineWidth: 1))
    }

    private func charge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(color.opacity(0.25), lineWidth: 1))
    }

    private func bond(_ a: CGPoint, _ b: CGPoint, compact: Bool, opacity: Double = 0.72, color: Color = .white) -> some View {
        LineShape(start: a, end: b)
            .stroke(color.opacity(opacity), style: StrokeStyle(lineWidth: compact ? 2.8 : 3.7, lineCap: .round))
    }

    private func dashedBond(_ a: CGPoint, _ b: CGPoint, compact: Bool) -> some View {
        LineShape(start: a, end: b)
            .stroke(
                ChemVaultTheme.softAccent.opacity(0.82),
                style: StrokeStyle(lineWidth: compact ? 2.2 : 3.0, lineCap: .round, dash: [6, 6])
            )
    }

    private func doubleBond(_ a: CGPoint, _ b: CGPoint, compact: Bool) -> some View {
        DoubleLineShape(start: a, end: b, offset: compact ? 4 : 5)
            .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: compact ? 2.3 : 3.1, lineCap: .round))
    }

    private func lonePairs() -> some View {
        HStack(spacing: 5) {
            Circle().fill(ChemVaultTheme.softAccent).frame(width: 6, height: 6)
            Circle().fill(ChemVaultTheme.softAccent).frame(width: 6, height: 6)
        }
        .shadow(color: ChemVaultTheme.softAccent.opacity(0.75), radius: 6)
    }

    private func glowRing(color: Color) -> some View {
        Circle()
            .stroke(color, lineWidth: 2)
            .blur(radius: 1.2)
            .shadow(color: color, radius: 16)
    }
}

struct FocusHalo: View {
    let color: Color

    var body: some View {
        Circle()
            .stroke(color.opacity(0.55), lineWidth: 2)
            .blur(radius: 0.6)
            .shadow(color: color.opacity(0.40), radius: 9)
            .scaleEffect(1.0)
    }
}

struct LabelChip: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(ChemVaultTheme.text)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.075))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(ChemVaultTheme.accent.opacity(0.22), lineWidth: 1)
            )
    }
}

struct EnergyCinemaOverlay: View {
    let step: CinemaStep

    private var progress: CGFloat {
        switch step {
        case .electronicPreparation:
            return 0.08
        case .lewisAcidActivation:
            return 0.22
        case .orbitalAlignment:
            return 0.36
        case .electronMovement:
            return 0.50
        case .magnesiumAlkoxide:
            return 0.72
        case .acidicWorkup:
            return 0.94
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Energy Focus")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.accent)

            GeometryReader { proxy in
                ZStack {
                    energyPath(size: proxy.size, progress: 1)
                        .stroke(.white.opacity(0.22), style: StrokeStyle(lineWidth: 3, lineCap: .round))

                    energyPath(size: proxy.size, progress: progress)
                        .stroke(
                            LinearGradient(
                                colors: [ChemVaultTheme.accent, ChemVaultTheme.softAccent, ChemVaultTheme.success],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )

                    Circle()
                        .fill(ChemVaultTheme.accent)
                        .frame(width: 16, height: 16)
                        .shadow(color: ChemVaultTheme.accent.opacity(0.65), radius: 10)
                        .position(markerPoint(size: proxy.size))
                }
            }

            HStack {
                Text("Reactants")
                Spacer()
                Text("TS")
                Spacer()
                Text("Alkoxide")
                Spacer()
                Text("Product")
            }
            .font(.caption2.bold())
            .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding(12)
        .background(.black.opacity(0.22))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }

    private func energyPath(size: CGSize, progress: CGFloat) -> Path {
        let path = Path { p in
            p.move(to: CGPoint(x: size.width * 0.04, y: size.height * 0.70))
            p.addCurve(
                to: CGPoint(x: size.width * 0.50, y: size.height * 0.22),
                control1: CGPoint(x: size.width * 0.18, y: size.height * 0.70),
                control2: CGPoint(x: size.width * 0.30, y: size.height * 0.12)
            )
            p.addCurve(
                to: CGPoint(x: size.width * 0.72, y: size.height * 0.62),
                control1: CGPoint(x: size.width * 0.58, y: size.height * 0.35),
                control2: CGPoint(x: size.width * 0.60, y: size.height * 0.66)
            )
            p.addCurve(
                to: CGPoint(x: size.width * 0.96, y: size.height * 0.76),
                control1: CGPoint(x: size.width * 0.82, y: size.height * 0.56),
                control2: CGPoint(x: size.width * 0.88, y: size.height * 0.76)
            )
        }

        return path.trimmedPath(from: 0, to: progress)
    }

    private func markerPoint(size: CGSize) -> CGPoint {
        switch step {
        case .electronicPreparation:
            return CGPoint(x: size.width * 0.08, y: size.height * 0.70)
        case .lewisAcidActivation:
            return CGPoint(x: size.width * 0.24, y: size.height * 0.54)
        case .orbitalAlignment:
            return CGPoint(x: size.width * 0.38, y: size.height * 0.30)
        case .electronMovement:
            return CGPoint(x: size.width * 0.50, y: size.height * 0.22)
        case .magnesiumAlkoxide:
            return CGPoint(x: size.width * 0.72, y: size.height * 0.62)
        case .acidicWorkup:
            return CGPoint(x: size.width * 0.94, y: size.height * 0.76)
        }
    }
}
