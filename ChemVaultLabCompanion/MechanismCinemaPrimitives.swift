import SwiftUI

struct CinemaPositions {
    let size: CGSize
    let compact: Bool
    
    var meCarbon: CGPoint { CGPoint(x: size.width * 0.22, y: size.height * 0.56) }
    var mg: CGPoint { CGPoint(x: size.width * 0.36, y: size.height * 0.56) }
    var br: CGPoint { CGPoint(x: size.width * 0.43, y: size.height * 0.65) }
    
    var carbonylC: CGPoint { CGPoint(x: size.width * 0.68, y: size.height * 0.57) }
    var oxygen: CGPoint { CGPoint(x: size.width * 0.68, y: size.height * 0.31) }
    var leftMethyl: CGPoint { CGPoint(x: size.width * 0.56, y: size.height * 0.72) }
    var rightMethyl: CGPoint { CGPoint(x: size.width * 0.80, y: size.height * 0.72) }
    var coordinatedMg: CGPoint { CGPoint(x: size.width * 0.55, y: size.height * 0.37) }
    
    var alkoxideC: CGPoint { CGPoint(x: size.width * 0.50, y: size.height * 0.56) }
    var alkoxideO: CGPoint { CGPoint(x: size.width * 0.50, y: size.height * 0.32) }
    var alkoxideLeft: CGPoint { CGPoint(x: size.width * 0.34, y: size.height * 0.69) }
    var alkoxideRight: CGPoint { CGPoint(x: size.width * 0.66, y: size.height * 0.69) }
    var alkoxideNewMe: CGPoint { CGPoint(x: size.width * 0.50, y: size.height * 0.83) }
    var alkoxideMg: CGPoint { CGPoint(x: size.width * 0.30, y: size.height * 0.36) }
}

struct CinemaAtom: View {
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
            Circle().fill(fill)
            Circle().stroke(.white.opacity(0.35), lineWidth: 1)
            Circle()
                .fill(.white.opacity(0.20))
                .frame(width: size * 0.34, height: size * 0.20)
                .offset(x: -size * 0.12, y: -size * 0.16)
                .blur(radius: 1)
            Text(label)
                .font(.system(size: max(8, size * 0.25), weight: .bold, design: .rounded))
                .foregroundStyle(role == .hydrogen ? .black.opacity(0.75) : .white)
                .minimumScaleFactor(0.45)
        }
        .frame(width: size, height: size)
        .shadow(color: glow, radius: role == .nucleophile || role == .oxygenCharged ? 13 : 7)
    }
    
    private var fill: RadialGradient {
        RadialGradient(colors: [.white.opacity(0.32), base, base.opacity(0.72)], center: .topLeading, startRadius: 2, endRadius: size)
    }
    
    private var base: Color {
        switch role {
        case .carbon: return Color(red: 0.17, green: 0.19, blue: 0.23)
        case .oxygen: return Color(red: 0.95, green: 0.18, blue: 0.18)
        case .oxygenCharged: return Color(red: 1.0, green: 0.16, blue: 0.12)
        case .nucleophile: return ChemVaultTheme.accent
        case .metal: return Color(red: 0.35, green: 0.56, blue: 1.0)
        case .bromide: return Color(red: 0.24, green: 0.78, blue: 0.42)
        case .hydrogen: return .white
        }
    }
    
    private var glow: Color {
        switch role {
        case .nucleophile: return ChemVaultTheme.accent.opacity(0.55)
        case .oxygenCharged: return .red.opacity(0.55)
        case .oxygen: return .red.opacity(0.25)
        default: return .black.opacity(0.28)
        }
    }
}

struct LineShape: Shape {
    let start: CGPoint
    let end: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct DoubleLineShape: Shape {
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

struct CinemaArrow: Shape {
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
            
            let p1 = CGPoint(x: current.x - arrowLength * cos(angle - arrowAngle),
                             y: current.y - arrowLength * sin(angle - arrowAngle))
            let p2 = CGPoint(x: current.x - arrowLength * cos(angle + arrowAngle),
                             y: current.y - arrowLength * sin(angle + arrowAngle))
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

struct ElectronPairFlight: View {
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
                    .shadow(color: ChemVaultTheme.softAccent.opacity(0.9), radius: 7)
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
        let u = 1 - t
        return CGPoint(
            x: u * u * start.x + 2 * u * t * control.x + t * t * end.x,
            y: u * u * start.y + 2 * u * t * control.y + t * t * end.y
        )
    }
}

struct OrbitalCloud: View {
    let color: Color
    
    var body: some View {
        Ellipse()
            .fill(RadialGradient(colors: [color, color.opacity(0.16), .clear], center: .center, startRadius: 4, endRadius: 80))
            .blur(radius: 1)
    }
}

struct PiStarCloud: View {
    var body: some View {
        ZStack {
            Ellipse()
                .fill(RadialGradient(colors: [Color.red.opacity(0.22), Color.red.opacity(0.08), .clear], center: .center, startRadius: 4, endRadius: 80))
                .offset(x: -10)
            Ellipse()
                .fill(RadialGradient(colors: [Color.red.opacity(0.18), Color.red.opacity(0.06), .clear], center: .center, startRadius: 4, endRadius: 80))
                .offset(x: 10)
        }
        .blur(radius: 1)
    }
}

struct MicroPanel: View {
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
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).stroke(.white.opacity(0.08), lineWidth: 1))
    }
}

struct MiniEnergyOverlay: View {
    let step: CinemaStep
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.065))
            AcademicEnergyProfileView(stepIndex: step.rawValue)
                .scaleEffect(0.78)
                .padding(-10)
        }
    }
}

struct CinemaGrid: View {
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
