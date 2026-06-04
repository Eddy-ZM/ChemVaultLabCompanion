import SwiftUI

struct PremiumMechanismTheatre: View {
    let step: Int
    let animationTrigger: Int
    
    @State private var attackProgress: CGFloat = 0
    @State private var piProgress: CGFloat = 0
    @State private var workupProgress: CGFloat = 0
    @State private var electronPulse = false
    
    var body: some View {
        GeometryReader { geometry in
            let isCompact = geometry.size.width < 430
            
            ZStack {
                molecularStageBackground
                
                if step == 0 {
                    reactantScene(isCompact: isCompact)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                } else if step == 1 {
                    alkoxideScene(isCompact: isCompact)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                } else {
                    productScene(isCompact: isCompact)
                        .transition(.opacity.combined(with: .scale(scale: 0.96)))
                }
                
                mechanismArrows(isCompact: isCompact)
            }
            .onChange(of: animationTrigger) { _, _ in
                runAnimation()
            }
            .onAppear {
                if step == 0 {
                    attackProgress = 0
                    piProgress = 0
                    workupProgress = 0
                }
            }
        }
    }
    
    private var molecularStageBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.055),
                            Color.white.opacity(0.025)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.10))
                .frame(width: 260, height: 260)
                .blur(radius: 42)
                .offset(x: -90, y: -50)
            
            Circle()
                .fill(Color.blue.opacity(0.08))
                .frame(width: 220, height: 220)
                .blur(radius: 50)
                .offset(x: 120, y: 70)
        }
    }
    
    // MARK: - Reactants
    
    private func reactantScene(isCompact: Bool) -> some View {
        ZStack {
            carbonylMolecule(isCompact: isCompact)
                .position(x: isCompact ? 235 : 430, y: isCompact ? 126 : 178)
            
            grignardMolecule(isCompact: isCompact)
                .position(x: isCompact ? 92 : 185, y: isCompact ? 128 : 180)
            
            Text("+")
                .font(.system(size: isCompact ? 24 : 34, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .position(x: isCompact ? 165 : 305, y: isCompact ? 128 : 180)
            
            chargeBadge("δ−", color: ChemVaultTheme.accent)
                .position(x: isCompact ? 78 : 165, y: isCompact ? 86 : 130)
            
            chargeBadge("δ+", color: .red.opacity(0.9))
                .position(x: isCompact ? 236 : 432, y: isCompact ? 154 : 216)
            
            chargeBadge("δ−", color: ChemVaultTheme.softAccent)
                .position(x: isCompact ? 235 : 430, y: isCompact ? 63 : 84)
        }
    }
    
    private func carbonylMolecule(isCompact: Bool) -> some View {
        let scale: CGFloat = isCompact ? 0.82 : 1.0
        
        return ZStack {
            BondLine(length: 74 * scale, angle: -28)
                .position(x: 58 * scale, y: 72 * scale)
            
            BondLine(length: 74 * scale, angle: 28)
                .position(x: 122 * scale, y: 72 * scale)
            
            DoubleBondLine(length: 78 * scale, angle: -90)
                .position(x: 90 * scale, y: 45 * scale)
            
            AtomNode(label: "C", role: .carbon, size: 38 * scale)
                .position(x: 90 * scale, y: 78 * scale)
            
            AtomNode(label: "O", role: .oxygen, size: 40 * scale)
                .position(x: 90 * scale, y: 0 * scale)
            
            GroupLabel("CH₃")
                .position(x: 28 * scale, y: 108 * scale)
            
            GroupLabel("CH₃")
                .position(x: 152 * scale, y: 108 * scale)
            
            Text("acetone")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .position(x: 90 * scale, y: 144 * scale)
        }
        .frame(width: 180 * scale, height: 160 * scale)
    }
    
    private func grignardMolecule(isCompact: Bool) -> some View {
        let scale: CGFloat = isCompact ? 0.82 : 1.0
        
        return ZStack {
            BondLine(length: 72 * scale, angle: 0)
                .position(x: 78 * scale, y: 50 * scale)
            
            AtomNode(label: "CH₃", role: .nucleophile, size: 46 * scale)
                .position(x: 38 * scale, y: 50 * scale)
            
            AtomNode(label: "MgBr", role: .metal, size: 50 * scale)
                .position(x: 120 * scale, y: 50 * scale)
            
            Text("MeMgBr")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .position(x: 78 * scale, y: 104 * scale)
        }
        .frame(width: 160 * scale, height: 120 * scale)
    }
    
    // MARK: - Alkoxide
    
    private func alkoxideScene(isCompact: Bool) -> some View {
        let scale: CGFloat = isCompact ? 0.82 : 1.0
        
        return ZStack {
            ZStack {
                BondLine(length: 72 * scale, angle: -90)
                    .position(x: 120 * scale, y: 78 * scale)
                
                BondLine(length: 74 * scale, angle: -28)
                    .position(x: 88 * scale, y: 104 * scale)
                
                BondLine(length: 74 * scale, angle: 28)
                    .position(x: 152 * scale, y: 104 * scale)
                
                BondLine(length: 74 * scale, angle: 90)
                    .position(x: 120 * scale, y: 138 * scale)
                
                AtomNode(label: "C", role: .carbon, size: 42 * scale)
                    .position(x: 120 * scale, y: 118 * scale)
                
                AtomNode(label: "O⁻", role: .oxygenCharged, size: 44 * scale)
                    .position(x: 120 * scale, y: 40 * scale)
                
                GroupLabel("CH₃")
                    .position(x: 46 * scale, y: 150 * scale)
                
                GroupLabel("CH₃")
                    .position(x: 194 * scale, y: 150 * scale)
                
                GroupLabel("CH₃")
                    .foregroundStyle(ChemVaultTheme.accent)
                    .position(x: 120 * scale, y: 198 * scale)
                
                LonePairDots()
                    .position(x: 154 * scale, y: 28 * scale)
                
                GlowRing(color: .red.opacity(0.45))
                    .frame(width: 86 * scale, height: 86 * scale)
                    .position(x: 120 * scale, y: 40 * scale)
                
                Text("tetrahedral alkoxide")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                    .position(x: 120 * scale, y: 238 * scale)
            }
            .frame(width: 260 * scale, height: 260 * scale)
            .position(x: isCompact ? 180 : 360, y: isCompact ? 150 : 200)
        }
    }
    
    // MARK: - Product
    
    private func productScene(isCompact: Bool) -> some View {
        let scale: CGFloat = isCompact ? 0.82 : 1.0
        
        return ZStack {
            ZStack {
                BondLine(length: 72 * scale, angle: -90)
                    .position(x: 120 * scale, y: 78 * scale)
                
                BondLine(length: 48 * scale, angle: 35)
                    .position(x: 143 * scale, y: 35 * scale)
                
                BondLine(length: 74 * scale, angle: -28)
                    .position(x: 88 * scale, y: 104 * scale)
                
                BondLine(length: 74 * scale, angle: 28)
                    .position(x: 152 * scale, y: 104 * scale)
                
                BondLine(length: 74 * scale, angle: 90)
                    .position(x: 120 * scale, y: 138 * scale)
                
                AtomNode(label: "C", role: .carbon, size: 42 * scale)
                    .position(x: 120 * scale, y: 118 * scale)
                
                AtomNode(label: "O", role: .oxygen, size: 44 * scale)
                    .position(x: 120 * scale, y: 40 * scale)
                
                AtomNode(label: "H", role: .hydrogen, size: 32 * scale)
                    .position(x: 168 * scale, y: 18 * scale)
                
                GroupLabel("CH₃")
                    .position(x: 46 * scale, y: 150 * scale)
                
                GroupLabel("CH₃")
                    .position(x: 194 * scale, y: 150 * scale)
                
                GroupLabel("CH₃")
                    .foregroundStyle(ChemVaultTheme.accent)
                    .position(x: 120 * scale, y: 198 * scale)
                
                GlowRing(color: ChemVaultTheme.success.opacity(0.45))
                    .frame(width: 210 * scale, height: 210 * scale)
                    .position(x: 120 * scale, y: 115 * scale)
                
                Text("tertiary alcohol")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                    .position(x: 120 * scale, y: 238 * scale)
            }
            .frame(width: 260 * scale, height: 260 * scale)
            .position(x: isCompact ? 180 : 360, y: isCompact ? 150 : 200)
        }
    }
    
    // MARK: - Mechanism arrows
    
    private func mechanismArrows(isCompact: Bool) -> some View {
        ZStack {
            if step == 0 || step == 1 {
                CurvedArrow2D(
                    start: CGPoint(x: isCompact ? 104 : 218, y: isCompact ? 124 : 174),
                    control: CGPoint(x: isCompact ? 157 : 292, y: isCompact ? 62 : 82),
                    end: CGPoint(x: isCompact ? 222 : 402, y: isCompact ? 129 : 178),
                    progress: attackProgress
                )
                .stroke(
                    ChemVaultTheme.accent,
                    style: StrokeStyle(lineWidth: isCompact ? 4 : 5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.accent.opacity(0.65), radius: 8)
                
                ElectronFlowParticles2D(
                    start: CGPoint(x: isCompact ? 104 : 218, y: isCompact ? 124 : 174),
                    control: CGPoint(x: isCompact ? 157 : 292, y: isCompact ? 62 : 82),
                    end: CGPoint(x: isCompact ? 222 : 402, y: isCompact ? 129 : 178),
                    active: electronPulse && step == 1
                )
                
                CurvedArrow2D(
                    start: CGPoint(x: isCompact ? 232 : 430, y: isCompact ? 110 : 160),
                    control: CGPoint(x: isCompact ? 255 : 460, y: isCompact ? 78 : 102),
                    end: CGPoint(x: isCompact ? 236 : 430, y: isCompact ? 66 : 86),
                    progress: piProgress
                )
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: isCompact ? 3.4 : 4.2, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.softAccent.opacity(0.5), radius: 6)
            }
            
            if step == 2 {
                CurvedArrow2D(
                    start: CGPoint(x: isCompact ? 246 : 460, y: isCompact ? 58 : 80),
                    control: CGPoint(x: isCompact ? 215 : 410, y: isCompact ? 32 : 42),
                    end: CGPoint(x: isCompact ? 184 : 362, y: isCompact ? 70 : 92),
                    progress: workupProgress
                )
                .stroke(
                    ChemVaultTheme.softAccent,
                    style: StrokeStyle(lineWidth: isCompact ? 3.8 : 4.5, lineCap: .round, lineJoin: .round)
                )
                .shadow(color: ChemVaultTheme.softAccent.opacity(0.55), radius: 7)
            }
        }
    }
    
    private func runAnimation() {
        if step == 1 {
            attackProgress = 0
            piProgress = 0
            electronPulse = false
            
            withAnimation(.easeInOut(duration: 0.95)) {
                attackProgress = 1
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                electronPulse = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.easeInOut(duration: 0.75)) {
                    piProgress = 1
                }
            }
        } else if step == 2 {
            workupProgress = 0
            
            withAnimation(.easeInOut(duration: 0.85)) {
                workupProgress = 1
            }
        } else {
            attackProgress = 0
            piProgress = 0
            workupProgress = 0
        }
    }
    
    private func chargeBadge(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption.bold())
            .foregroundStyle(color)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background(.white.opacity(0.08))
            .clipShape(Capsule())
    }
}

// MARK: - Small components

struct AtomNode: View {
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
    
    var body: some View {
        ZStack {
            Circle()
                .fill(radialFill)
                .shadow(color: glowColor, radius: 10)
            
            Circle()
                .stroke(.white.opacity(0.35), lineWidth: 1)
            
            Text(label)
                .font(.system(size: max(10, size * 0.30), weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .minimumScaleFactor(0.55)
        }
        .frame(width: size, height: size)
    }
    
    private var radialFill: RadialGradient {
        RadialGradient(
            colors: [
                .white.opacity(0.28),
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
            return Color(red: 0.18, green: 0.20, blue: 0.24)
        case .oxygen:
            return Color(red: 0.94, green: 0.18, blue: 0.18)
        case .oxygenCharged:
            return Color(red: 1.00, green: 0.20, blue: 0.16)
        case .nucleophile:
            return ChemVaultTheme.accent
        case .metal:
            return Color(red: 0.34, green: 0.56, blue: 1.00)
        case .hydrogen:
            return .white.opacity(0.92)
        }
    }
    
    private var glowColor: Color {
        switch role {
        case .oxygenCharged:
            return .red.opacity(0.55)
        case .nucleophile:
            return ChemVaultTheme.accent.opacity(0.55)
        default:
            return .black.opacity(0.28)
        }
    }
}

struct GroupLabel: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 15, weight: .bold, design: .rounded))
            .foregroundStyle(ChemVaultTheme.text)
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

struct BondLine: View {
    let length: CGFloat
    let angle: Double
    
    var body: some View {
        Capsule()
            .fill(.white.opacity(0.72))
            .frame(width: length, height: 3)
            .rotationEffect(.degrees(angle))
    }
}

struct DoubleBondLine: View {
    let length: CGFloat
    let angle: Double
    
    var body: some View {
        ZStack {
            Capsule()
                .fill(.white.opacity(0.72))
                .frame(width: length, height: 2.6)
                .offset(y: -3)
            
            Capsule()
                .fill(.white.opacity(0.72))
                .frame(width: length, height: 2.6)
                .offset(y: 3)
        }
        .rotationEffect(.degrees(angle))
    }
}

struct CurvedArrow2D: Shape {
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

struct ElectronFlowParticles2D: View {
    let start: CGPoint
    let control: CGPoint
    let end: CGPoint
    let active: Bool
    
    @State private var phase: CGFloat = 0
    
    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Circle()
                    .fill(ChemVaultTheme.softAccent)
                    .frame(width: 7, height: 7)
                    .shadow(color: ChemVaultTheme.softAccent.opacity(0.8), radius: 6)
                    .position(point(t: max(0, min(1, phase - CGFloat(index) * 0.12))))
                    .opacity(active ? 1 : 0)
            }
        }
        .onChange(of: active) { _, newValue in
            if newValue {
                phase = 0
                withAnimation(.linear(duration: 0.95)) {
                    phase = 1.55
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

struct LonePairDots: View {
    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
            Circle()
                .fill(ChemVaultTheme.softAccent)
                .frame(width: 6, height: 6)
        }
        .shadow(color: ChemVaultTheme.softAccent.opacity(0.7), radius: 5)
    }
}

struct GlowRing: View {
    let color: Color
    
    var body: some View {
        Circle()
            .stroke(color, lineWidth: 2)
            .blur(radius: 1)
            .shadow(color: color, radius: 14)
    }
}
