import SwiftUI

struct ChallengeVisual: View {
    let mode: ChallengeVisualMode

    @State private var arrowProgress: CGFloat = 0
    @State private var electronFlow = false

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                visualBackground

                switch mode {
                case .nucleophile:
                    nucleophileVisual(size: size)
                case .electronFlow:
                    electronFlowVisual(size: size)
                case .intermediate:
                    intermediateVisual(size: size)
                case .workup:
                    workupVisual(size: size)
                }
            }
            .onAppear {
                arrowProgress = 0
                electronFlow = false

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        arrowProgress = 1
                    }
                    electronFlow = true
                }
            }
        }
    }

    private var visualBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.065),
                            .white.opacity(0.025),
                            .black.opacity(0.14)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.10))
                .frame(width: 200, height: 200)
                .blur(radius: 36)
                .offset(x: -70, y: -40)
        }
    }

    private func nucleophileVisual(size: CGSize) -> some View {
        ZStack {
            simpleBond(
                from: CGPoint(x: size.width * 0.34, y: size.height * 0.52),
                to: CGPoint(x: size.width * 0.58, y: size.height * 0.52)
            )

            challengeAtom("CH₃", role: .nucleophile)
                .position(x: size.width * 0.34, y: size.height * 0.52)

            challengeAtom("MgBr", role: .metal)
                .position(x: size.width * 0.58, y: size.height * 0.52)

            Text("δ−")
                .font(.title3.bold())
                .foregroundStyle(ChemVaultTheme.accent)
                .position(x: size.width * 0.34, y: size.height * 0.28)

            Text("Tap the nucleophilic site")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .position(x: size.width * 0.50, y: size.height * 0.82)
        }
    }

    private func electronFlowVisual(size: CGSize) -> some View {
        let start = CGPoint(x: size.width * 0.30, y: size.height * 0.58)
        let control = CGPoint(x: size.width * 0.48, y: size.height * 0.24)
        let end = CGPoint(x: size.width * 0.68, y: size.height * 0.58)

        return ZStack {
            challengeAtom("CH₃", role: .nucleophile)
                .position(start)

            challengeAtom("C=O", role: .carbon)
                .position(end)

            ChallengeArrow(start: start, control: control, end: end, progress: arrowProgress)
                .stroke(
                    ChemVaultTheme.accent,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.accent.opacity(0.7), radius: 8)

            ElectronPairFlight(
                start: start,
                control: control,
                end: end,
                active: electronFlow
            )
        }
    }

    private func intermediateVisual(size: CGSize) -> some View {
        ZStack {
            let c = CGPoint(x: size.width * 0.50, y: size.height * 0.52)
            let o = CGPoint(x: size.width * 0.50, y: size.height * 0.28)
            let left = CGPoint(x: size.width * 0.32, y: size.height * 0.66)
            let right = CGPoint(x: size.width * 0.68, y: size.height * 0.66)
            let bottom = CGPoint(x: size.width * 0.50, y: size.height * 0.82)

            simpleBond(from: c, to: o)
            simpleBond(from: c, to: left)
            simpleBond(from: c, to: right)
            simpleBond(from: c, to: bottom)

            challengeAtom("O⁻", role: .oxygenCharged)
                .position(o)

            challengeAtom("C", role: .carbon)
                .position(c)

            challengeGroup("CH₃").position(left)
            challengeGroup("CH₃").position(right)
            challengeGroup("CH₃").position(bottom)
        }
    }

    private func workupVisual(size: CGSize) -> some View {
        let start = CGPoint(x: size.width * 0.72, y: size.height * 0.26)
        let control = CGPoint(x: size.width * 0.62, y: size.height * 0.12)
        let end = CGPoint(x: size.width * 0.50, y: size.height * 0.34)

        return ZStack {
            challengeAtom("O⁻", role: .oxygenCharged)
                .position(x: size.width * 0.48, y: size.height * 0.45)

            challengeAtom("H⁺", role: .hydrogen)
                .position(start)

            ChallengeArrow(start: start, control: control, end: end, progress: arrowProgress)
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round)
                )

            Text("O⁻ → OH")
                .font(.headline.bold())
                .foregroundStyle(ChemVaultTheme.success)
                .position(x: size.width * 0.50, y: size.height * 0.78)
        }
    }

    private func challengeAtom(_ label: String, role: CinemaAtom.Role) -> some View {
        CinemaAtom(label: label, role: role, size: 54)
    }

    private func challengeGroup(_ label: String) -> some View {
        Text(label)
            .font(.caption.bold())
            .foregroundStyle(ChemVaultTheme.text)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
    }

    private func simpleBond(from: CGPoint, to: CGPoint) -> some View {
        LineShape(start: from, end: to)
            .stroke(.white.opacity(0.72), style: StrokeStyle(lineWidth: 3, lineCap: .round))
    }
}

struct ChallengeArrow: Shape {
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
        let u = 1 - t
        return CGPoint(
            x: u * u * start.x + 2 * u * t * control.x + t * t * end.x,
            y: u * u * start.y + 2 * u * t * control.y + t * t * end.y
        )
    }
}
