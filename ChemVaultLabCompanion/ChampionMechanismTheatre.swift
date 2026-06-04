import SwiftUI

struct ChampionMechanismTheatre: View {
    let stepIndex: Int
    let animationTrigger: Int

    @State private var attackProgress: CGFloat = 0
    @State private var piProgress: CGFloat = 0
    @State private var coordinationProgress: CGFloat = 0
    @State private var protonProgress: CGFloat = 0
    @State private var productReveal: CGFloat = 0
    @State private var electronFlow = false

    @State private var tiltX: CGFloat = -6
    @State private var tiltY: CGFloat = 0
    @State private var lastTiltX: CGFloat = -6
    @State private var lastTiltY: CGFloat = 0

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let isCompact = size.width < 430

            ZStack {
                championStageBackground

                ZStack {
                    switch stepIndex {
                    case 0:
                        polarisationScene(size: size, isCompact: isCompact)
                    case 1:
                        coordinationScene(size: size, isCompact: isCompact)
                    case 2:
                        additionScene(size: size, isCompact: isCompact)
                    case 3:
                        alkoxideScene(size: size, isCompact: isCompact)
                    default:
                        workupScene(size: size, isCompact: isCompact)
                    }
                }
                .rotation3DEffect(.degrees(tiltY), axis: (x: 0, y: 1, z: 0), perspective: 0.72)
                .rotation3DEffect(.degrees(tiltX), axis: (x: 1, y: 0, z: 0), perspective: 0.72)
                .animation(.spring(response: 0.55, dampingFraction: 0.84), value: stepIndex)

                academicOverlay(size: size, isCompact: isCompact)
            }
            .contentShape(Rectangle())
            .gesture(rotationGesture)
            .onAppear {
                prepareAnimation()
            }
            .onChange(of: stepIndex) { _, _ in
                prepareAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    runAnimation()
                }
            }
            .onChange(of: animationTrigger) { _, _ in
                runAnimation()
            }
        }
    }

    // MARK: - Background

    private var championStageBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.075),
                            Color.white.opacity(0.030),
                            Color.black.opacity(0.18)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.11))
                .frame(width: 295, height: 295)
                .blur(radius: 62)
                .offset(x: -120, y: -75)

            Circle()
                .fill(Color.red.opacity(0.065))
                .frame(width: 250, height: 250)
                .blur(radius: 58)
                .offset(x: 135, y: 95)

            ChampionGrid()
                .opacity(0.18)
        }
    }

    // MARK: - Scenes

    private func polarisationScene(size: CGSize, isCompact: Bool) -> some View {
        let methyl = CGPoint(x: size.width * 0.22, y: size.height * 0.56)
        let mg = CGPoint(x: size.width * 0.36, y: size.height * 0.56)
        let br = CGPoint(x: size.width * 0.43, y: size.height * 0.65)

        let c = CGPoint(x: size.width * 0.68, y: size.height * 0.57)
        let o = CGPoint(x: size.width * 0.68, y: size.height * 0.31)
        let leftMe = CGPoint(x: size.width * 0.56, y: size.height * 0.72)
        let rightMe = CGPoint(x: size.width * 0.80, y: size.height * 0.72)

        return ZStack {
            reactantBonds(methyl: methyl, mg: mg, br: br, c: c, o: o, leftMe: leftMe, rightMe: rightMe, isCompact: isCompact)

            ChampionOrbital(color: ChemVaultTheme.accent.opacity(0.30))
                .frame(width: isCompact ? 78 : 100, height: isCompact ? 40 : 52)
                .position(x: methyl.x - 4, y: methyl.y)

            ChampionPiCloud()
                .frame(width: isCompact ? 60 : 76, height: isCompact ? 96 : 120)
                .position(x: c.x, y: (c.y + o.y) / 2)

            championAtoms(methyl: methyl, mg: mg, br: br, c: c, o: o, leftMe: leftMe, rightMe: rightMe, isCompact: isCompact)

            ChampionChargeBadge("δ−", color: ChemVaultTheme.accent)
                .position(x: methyl.x, y: methyl.y - (isCompact ? 36 : 46))

            ChampionChargeBadge("δ+", color: ChemVaultTheme.softAccent)
                .position(x: mg.x, y: mg.y - (isCompact ? 36 : 46))

            ChampionChargeBadge("δ+", color: .red.opacity(0.95))
                .position(x: c.x + (isCompact ? 34 : 44), y: c.y - 6)

            ChampionChargeBadge("δ−", color: ChemVaultTheme.softAccent)
                .position(x: o.x, y: o.y - (isCompact ? 34 : 42))

            Text("+")
                .font(.system(size: isCompact ? 22 : 32, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .position(x: size.width * 0.50, y: size.height * 0.56)
        }
    }

    private func coordinationScene(size: CGSize, isCompact: Bool) -> some View {
        let methyl = CGPoint(x: size.width * 0.21, y: size.height * 0.58)
        let mg = CGPoint(x: size.width * 0.35, y: size.height * 0.58)
        let br = CGPoint(x: size.width * 0.42, y: size.height * 0.67)

        let c = CGPoint(x: size.width * 0.68, y: size.height * 0.58)
        let o = CGPoint(x: size.width * 0.68, y: size.height * 0.32)
        let leftMe = CGPoint(x: size.width * 0.56, y: size.height * 0.73)
        let rightMe = CGPoint(x: size.width * 0.80, y: size.height * 0.73)
        let coordinatedMg = CGPoint(
            x: interpolate(from: size.width * 0.43, to: size.width * 0.55, progress: coordinationProgress),
            y: interpolate(from: size.height * 0.67, to: size.height * 0.37, progress: coordinationProgress)
        )

        return ZStack {
            reactantBonds(methyl: methyl, mg: mg, br: br, c: c, o: o, leftMe: leftMe, rightMe: rightMe, isCompact: isCompact)

            ChampionDashedBond(start: o, end: coordinatedMg)
                .stroke(
                    ChemVaultTheme.softAccent.opacity(0.85),
                    style: StrokeStyle(lineWidth: isCompact ? 2.4 : 3.2, lineCap: .round, dash: [6, 6])
                )

            ChampionCurvedArrow(
                start: CGPoint(x: o.x - 4, y: o.y + 8),
                control: CGPoint(x: size.width * 0.60, y: size.height * 0.20),
                end: coordinatedMg,
                progress: coordinationProgress
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: isCompact ? 3.0 : 4.0, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: ChemVaultTheme.softAccent.opacity(0.6), radius: 8)

            ChampionPiCloud()
                .frame(width: isCompact ? 60 : 76, height: isCompact ? 96 : 120)
                .position(x: c.x, y: (c.y + o.y) / 2)

            championAtoms(methyl: methyl, mg: mg, br: br, c: c, o: o, leftMe: leftMe, rightMe: rightMe, isCompact: isCompact)

            ChampionAtom(label: "MgBr⁺", role: .metal, size: isCompact ? 42 : 50)
                .position(coordinatedMg)
                .opacity(Double(coordinationProgress))

            ChampionLabel("O: → MgBr⁺")
                .position(x: size.width * 0.58, y: size.height * 0.20)
        }
    }

    private func additionScene(size: CGSize, isCompact: Bool) -> some View {
        let approach = attackProgress

        let methyl = CGPoint(
            x: interpolate(from: size.width * 0.22, to: size.width * 0.45, progress: approach),
            y: interpolate(from: size.height * 0.58, to: size.height * 0.58, progress: approach)
        )
        let mg = CGPoint(
            x: interpolate(from: size.width * 0.36, to: size.width * 0.30, progress: approach),
            y: size.height * 0.58
        )
        let br = CGPoint(x: mg.x + size.width * 0.07, y: mg.y + size.height * 0.09)

        let c = CGPoint(x: size.width * 0.68, y: size.height * 0.58)
        let o = CGPoint(
            x: size.width * 0.68,
            y: interpolate(from: size.height * 0.32, to: size.height * 0.26, progress: piProgress)
        )
        let leftMe = CGPoint(x: size.width * 0.56, y: size.height * 0.73)
        let rightMe = CGPoint(x: size.width * 0.80, y: size.height * 0.73)

        return ZStack {
            reactantBonds(methyl: methyl, mg: mg, br: br, c: c, o: o, leftMe: leftMe, rightMe: rightMe, isCompact: isCompact)

            ChampionCurvedArrow(
                start: methyl,
                control: CGPoint(x: size.width * 0.48, y: size.height * 0.20),
                end: c,
                progress: attackProgress
            )
            .stroke(
                ChemVaultTheme.accent,
                style: StrokeStyle(lineWidth: isCompact ? 4.0 : 5.0, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: ChemVaultTheme.accent.opacity(0.7), radius: 10)

            ChampionElectronStream(
                start: methyl,
                control: CGPoint(x: size.width * 0.48, y: size.height * 0.20),
                end: c,
                active: electronFlow,
                color: ChemVaultTheme.softAccent
            )

            ChampionCurvedArrow(
                start: CGPoint(x: c.x, y: c.y - 16),
                control: CGPoint(x: size.width * 0.76, y: size.height * 0.24),
                end: o,
                progress: piProgress
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: isCompact ? 3.2 : 4.2, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: ChemVaultTheme.softAccent.opacity(0.55), radius: 8)

            ChampionPiCloud()
                .frame(width: isCompact ? 60 : 76, height: isCompact ? 96 : 120)
                .position(x: c.x, y: (c.y + o.y) / 2)
                .opacity(1 - Double(piProgress) * 0.72)

            championAtoms(methyl: methyl, mg: mg, br: br, c: c, o: o, leftMe: leftMe, rightMe: rightMe, isCompact: isCompact)

            ChampionBond(start: methyl, end: c)
                .stroke(
                    ChemVaultTheme.accent.opacity(attackProgress),
                    style: StrokeStyle(lineWidth: isCompact ? 3.0 : 4.0, lineCap: .round)
                )

            ChampionLabel("C–C bond forming")
                .position(x: size.width * 0.51, y: size.height * 0.82)
        }
    }

    private func alkoxideScene(size: CGSize, isCompact: Bool) -> some View {
        let center = CGPoint(x: size.width * 0.50, y: size.height * 0.56)
        return alkoxideMolecule(center: center, size: size, isCompact: isCompact, showMagnesium: true)
    }

    private func workupScene(size: CGSize, isCompact: Bool) -> some View {
        let center = CGPoint(x: size.width * 0.50, y: size.height * 0.56)
        let hStart = CGPoint(x: size.width * 0.75, y: size.height * 0.24)
        let hEnd = CGPoint(x: center.x + size.width * 0.07, y: center.y - size.height * 0.30)
        let hPosition = CGPoint(
            x: interpolate(from: hStart.x, to: hEnd.x, progress: protonProgress),
            y: interpolate(from: hStart.y, to: hEnd.y, progress: protonProgress)
        )

        return ZStack {
            alkoxideMolecule(center: center, size: size, isCompact: isCompact, showMagnesium: productReveal < 0.5)
                .opacity(1 - Double(productReveal))

            alcoholMolecule(center: center, size: size, isCompact: isCompact)
                .opacity(Double(productReveal))
                .scaleEffect(0.96 + 0.04 * productReveal)

            ChampionCurvedArrow(
                start: hStart,
                control: CGPoint(x: size.width * 0.64, y: size.height * 0.15),
                end: hEnd,
                progress: protonProgress
            )
            .stroke(
                ChemVaultTheme.softAccent,
                style: StrokeStyle(lineWidth: isCompact ? 3.4 : 4.4, lineCap: .round, lineJoin: .round)
            )
            .shadow(color: ChemVaultTheme.softAccent.opacity(0.55), radius: 8)

            ChampionAtom(label: "H⁺", role: .hydrogen, size: isCompact ? 32 : 38)
                .position(hPosition)
                .opacity(1 - Double(productReveal))

            ChampionLabel("acid workup")
                .position(x: size.width * 0.70, y: size.height * 0.18)
        }
    }

    // MARK: - Molecule Helpers

    private func reactantBonds(
        methyl: CGPoint,
        mg: CGPoint,
        br: CGPoint,
        c: CGPoint,
        o: CGPoint,
        leftMe: CGPoint,
        rightMe: CGPoint,
        isCompact: Bool
    ) -> some View {
        ZStack {
            ChampionBond(start: methyl, end: mg)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 3 : 4, lineCap: .round))

            ChampionBond(start: mg, end: br)
                .stroke(.white.opacity(0.58), style: StrokeStyle(lineWidth: isCompact ? 2.4 : 3.2, lineCap: .round))

            ChampionDoubleBond(start: c, end: o, offset: isCompact ? 4 : 5)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.4 : 3.2, lineCap: .round))

            ChampionBond(start: c, end: leftMe)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.6 : 3.4, lineCap: .round))

            ChampionBond(start: c, end: rightMe)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.6 : 3.4, lineCap: .round))
        }
    }

    private func championAtoms(
        methyl: CGPoint,
        mg: CGPoint,
        br: CGPoint,
        c: CGPoint,
        o: CGPoint,
        leftMe: CGPoint,
        rightMe: CGPoint,
        isCompact: Bool
    ) -> some View {
        ZStack {
            ChampionAtom(label: "CH₃", role: .nucleophile, size: isCompact ? 42 : 52)
                .position(methyl)

            ChampionAtom(label: "Mg", role: .metal, size: isCompact ? 38 : 46)
                .position(mg)

            ChampionAtom(label: "Br", role: .bromide, size: isCompact ? 34 : 40)
                .position(br)

            ChampionAtom(label: "C", role: .carbon, size: isCompact ? 38 : 46)
                .position(c)

            ChampionAtom(label: "O", role: .oxygen, size: isCompact ? 40 : 48)
                .position(o)

            ChampionGroup("CH₃")
                .position(leftMe)

            ChampionGroup("CH₃")
                .position(rightMe)
        }
    }

    private func alkoxideMolecule(center: CGPoint, size: CGSize, isCompact: Bool, showMagnesium: Bool) -> some View {
        let c = center
        let o = CGPoint(x: center.x, y: center.y - size.height * 0.24)
        let leftMe = CGPoint(x: center.x - size.width * 0.16, y: center.y + size.height * 0.13)
        let rightMe = CGPoint(x: center.x + size.width * 0.16, y: center.y + size.height * 0.13)
        let newMe = CGPoint(x: center.x, y: center.y + size.height * 0.27)
        let mg = CGPoint(x: center.x - size.width * 0.20, y: center.y - size.height * 0.20)

        return ZStack {
            ChampionGlow(color: .red.opacity(0.38))
                .frame(width: isCompact ? 72 : 90, height: isCompact ? 72 : 90)
                .position(o)

            ChampionBond(start: c, end: o)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 3 : 4, lineCap: .round))
            ChampionBond(start: c, end: leftMe)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.7 : 3.6, lineCap: .round))
            ChampionBond(start: c, end: rightMe)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.7 : 3.6, lineCap: .round))
            ChampionBond(start: c, end: newMe)
                .stroke(ChemVaultTheme.accent.opacity(0.85), style: StrokeStyle(lineWidth: isCompact ? 3.0 : 4.0, lineCap: .round))

            if showMagnesium {
                ChampionDashedBond(start: o, end: mg)
                    .stroke(
                        ChemVaultTheme.softAccent.opacity(0.82),
                        style: StrokeStyle(lineWidth: isCompact ? 2.2 : 3.0, lineCap: .round, dash: [6, 6])
                    )

                ChampionAtom(label: "MgBr⁺", role: .metal, size: isCompact ? 38 : 46)
                    .position(mg)
            }

            ChampionAtom(label: "O⁻", role: .oxygenCharged, size: isCompact ? 42 : 52)
                .position(o)

            ChampionAtom(label: "C", role: .carbon, size: isCompact ? 40 : 48)
                .position(c)

            ChampionGroup("CH₃")
                .position(leftMe)
            ChampionGroup("CH₃")
                .position(rightMe)
            ChampionGroup("CH₃", color: ChemVaultTheme.accent)
                .position(newMe)

            ChampionLonePairs()
                .position(x: o.x + (isCompact ? 30 : 40), y: o.y - (isCompact ? 12 : 16))
        }
    }

    private func alcoholMolecule(center: CGPoint, size: CGSize, isCompact: Bool) -> some View {
        let c = center
        let o = CGPoint(x: center.x, y: center.y - size.height * 0.24)
        let h = CGPoint(x: center.x + size.width * 0.11, y: center.y - size.height * 0.33)
        let leftMe = CGPoint(x: center.x - size.width * 0.16, y: center.y + size.height * 0.13)
        let rightMe = CGPoint(x: center.x + size.width * 0.16, y: center.y + size.height * 0.13)
        let newMe = CGPoint(x: center.x, y: center.y + size.height * 0.27)

        return ZStack {
            ChampionGlow(color: ChemVaultTheme.success.opacity(0.38))
                .frame(width: isCompact ? 200 : 250, height: isCompact ? 200 : 250)
                .position(c)

            ChampionBond(start: c, end: o)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 3 : 4, lineCap: .round))
            ChampionBond(start: o, end: h)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.5 : 3.2, lineCap: .round))
            ChampionBond(start: c, end: leftMe)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.7 : 3.6, lineCap: .round))
            ChampionBond(start: c, end: rightMe)
                .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: isCompact ? 2.7 : 3.6, lineCap: .round))
            ChampionBond(start: c, end: newMe)
                .stroke(ChemVaultTheme.accent.opacity(0.85), style: StrokeStyle(lineWidth: isCompact ? 3.0 : 4.0, lineCap: .round))

            ChampionAtom(label: "O", role: .oxygen, size: isCompact ? 42 : 52)
                .position(o)

            ChampionAtom(label: "H", role: .hydrogen, size: isCompact ? 30 : 36)
                .position(h)

            ChampionAtom(label: "C", role: .carbon, size: isCompact ? 40 : 48)
                .position(c)

            ChampionGroup("CH₃")
                .position(leftMe)
            ChampionGroup("CH₃")
                .position(rightMe)
            ChampionGroup("CH₃", color: ChemVaultTheme.accent)
                .position(newMe)
        }
    }

    // MARK: - Overlay

    private func academicOverlay(size: CGSize, isCompact: Bool) -> some View {
        VStack {
            HStack {
                ChampionMicroHUD(title: hudTitle, value: hudValue)
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                ChampionMicroHUD(title: "Gesture", value: "Drag to tilt")
            }
        }
        .padding(isCompact ? 10 : 14)
    }

    private var hudTitle: String {
        switch stepIndex {
        case 0: return "Electronic state"
        case 1: return "Lewis acid step"
        case 2: return "Electron flow"
        case 3: return "Intermediate"
        default: return "Workup"
        }
    }

    private var hudValue: String {
        switch stepIndex {
        case 0: return "Polarised bonds"
        case 1: return "O→Mg coordination"
        case 2: return "C–C forming"
        case 3: return "Mg alkoxide"
        default: return "O⁻ → OH"
        }
    }

    // MARK: - Motion

    private var rotationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                tiltY = lastTiltY + value.translation.width * 0.18
                tiltX = lastTiltX - value.translation.height * 0.12
                tiltX = min(16, max(-20, tiltX))
            }
            .onEnded { _ in
                lastTiltX = tiltX
                lastTiltY = tiltY
            }
    }

    private func prepareAnimation() {
        coordinationProgress = stepIndex >= 1 ? 1 : 0
        attackProgress = stepIndex >= 2 ? 1 : 0
        piProgress = stepIndex >= 2 ? 1 : 0
        protonProgress = stepIndex >= 4 ? 1 : 0
        productReveal = stepIndex >= 4 ? 1 : 0
        electronFlow = false
    }

    private func runAnimation() {
        switch stepIndex {
        case 1:
            coordinationProgress = 0
            withAnimation(.easeInOut(duration: 0.95)) {
                coordinationProgress = 1
                tiltY = -8
                tiltX = -8
            }

        case 2:
            attackProgress = 0
            piProgress = 0
            electronFlow = false

            withAnimation(.easeInOut(duration: 1.05)) {
                attackProgress = 1
                tiltY = -14
                tiltX = -10
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                electronFlow = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.34) {
                withAnimation(.easeInOut(duration: 0.78)) {
                    piProgress = 1
                }
            }

        case 3:
            withAnimation(.spring(response: 0.6, dampingFraction: 0.82)) {
                tiltY = 14
                tiltX = -8
            }

        case 4:
            protonProgress = 0
            productReveal = 0

            withAnimation(.easeInOut(duration: 0.9)) {
                protonProgress = 1
                tiltY = -12
                tiltX = -6
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
                    productReveal = 1
                    tiltY = 10
                }
            }

        default:
            withAnimation(.spring(response: 0.6, dampingFraction: 0.84)) {
                tiltX = -6
                tiltY = 0
            }
        }

        lastTiltX = tiltX
        lastTiltY = tiltY
    }

    private func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
        from + (to - from) * progress
    }
}

// MARK: - Drawing Components

struct ChampionAtom: View {
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
                .stroke(.white.opacity(0.35), lineWidth: 1)

            Circle()
                .fill(.white.opacity(0.22))
                .frame(width: size * 0.34, height: size * 0.20)
                .offset(x: -size * 0.12, y: -size * 0.16)
                .blur(radius: 1)

            Text(label)
                .font(.system(size: max(8, size * 0.25), weight: .bold, design: .rounded))
                .foregroundStyle(role == .hydrogen ? .black.opacity(0.75) : .white)
                .minimumScaleFactor(0.50)
        }
        .frame(width: size, height: size)
        .shadow(color: glowColor, radius: role == .nucleophile || role == .oxygenCharged ? 14 : 8)
    }

    private var atomGradient: RadialGradient {
        RadialGradient(
            colors: [
                .white.opacity(0.32),
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
            return Color(red: 1.00, green: 0.18, blue: 0.13)
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
        case .nucleophile:
            return ChemVaultTheme.accent.opacity(0.55)
        case .oxygenCharged:
            return .red.opacity(0.55)
        case .oxygen:
            return .red.opacity(0.25)
        default:
            return .black.opacity(0.28)
        }
    }
}

struct ChampionGroup: View {
    let text: String
    let color: Color

    init(_ text: String, color: Color = ChemVaultTheme.text) {
        self.text = text
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.12), lineWidth: 1)
            )
    }
}

struct ChampionChargeBadge: View {
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

struct ChampionBond: Shape {
    let start: CGPoint
    let end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct ChampionDashedBond: Shape {
    let start: CGPoint
    let end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct ChampionDoubleBond: Shape {
    let start: CGPoint
    let end: CGPoint
    let offset: CGFloat

    func path(in rect: CGRect) -> Path {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = max(1, sqrt(dx * dx + dy * dy))
        let nx = -dy / length * offset
        let ny = dx / length * offset

        var path = Path()
        path.move(to: CGPoint(x: start.x + nx, y: start.y + ny))
        path.addLine(to: CGPoint(x: end.x + nx, y: end.y + ny))
        path.move(to: CGPoint(x: start.x - nx, y: start.y - ny))
        path.addLine(to: CGPoint(x: end.x - nx, y: end.y - ny))
        return path
    }
}

struct ChampionCurvedArrow: Shape {
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
        let current = point(t: t)

        var path = Path()
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

    private func point(t: CGFloat) -> CGPoint {
        let oneMinus = 1 - t
        let x = oneMinus * oneMinus * start.x + 2 * oneMinus * t * control.x + t * t * end.x
        let y = oneMinus * oneMinus * start.y + 2 * oneMinus * t * control.y + t * t * end.y
        return CGPoint(x: x, y: y)
    }
}

struct ChampionElectronStream: View {
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
                withAnimation(.linear(duration: 1.0)) {
                    phase = 1.65
                }
            }
        }
    }

    private func point(t: CGFloat) -> CGPoint {
        let oneMinus = 1 - t
        let x = oneMinus * oneMinus * start.x + 2 * oneMinus * t * control.x + t * t * end.x
        let y = oneMinus * oneMinus * start.y + 2 * oneMinus * t * control.y + t * t * end.y
        return CGPoint(x: x, y: y)
    }
}

struct ChampionOrbital: View {
    let color: Color

    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [
                        color,
                        color.opacity(0.16),
                        .clear
                    ],
                    center: .center,
                    startRadius: 4,
                    endRadius: 70
                )
            )
            .blur(radius: 1)
    }
}

struct ChampionPiCloud: View {
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
                .offset(x: -10)

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
                .offset(x: 10)
        }
        .blur(radius: 1)
    }
}

struct ChampionLonePairs: View {
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
        }
        .shadow(color: ChemVaultTheme.softAccent.opacity(0.75), radius: 6)
    }
}

struct ChampionGlow: View {
    let color: Color

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 2)
            .blur(radius: 1.2)
            .shadow(color: color, radius: 16)
    }
}

struct ChampionLabel: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(ChemVaultTheme.accent)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(ChemVaultTheme.accent.opacity(0.20), lineWidth: 1)
            )
    }
}

struct ChampionMicroHUD: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
            Text(value)
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.text)
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 8)
        .background(.white.opacity(0.065))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

struct ChampionGrid: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 28

            for x in stride(from: CGFloat(0), through: size.width, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.white.opacity(0.08)), lineWidth: 0.5)
            }

            for y in stride(from: CGFloat(0), through: size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.white.opacity(0.065)), lineWidth: 0.5)
            }
        }
    }
}
