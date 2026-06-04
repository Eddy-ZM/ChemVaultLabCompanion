import SwiftUI

struct AcademicEnergyProfileView: View {
    let stepIndex: Int
    
    private var progress: CGFloat {
        switch stepIndex {
        case 0: return 0.08
        case 1: return 0.22
        case 2: return 0.48
        case 3: return 0.70
        default: return 0.94
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "chart.xyaxis.line")
                    .foregroundStyle(ChemVaultTheme.accent)
                
                Text("Reaction Coordinate")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)
                
                Spacer()
            }
            
            GeometryReader { proxy in
                ZStack {
                    coordinateCurve(size: proxy.size)
                        .stroke(.white.opacity(0.28), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    
                    coordinateCurve(size: proxy.size, progress: progress)
                        .stroke(
                            LinearGradient(
                                colors: [ChemVaultTheme.accent, ChemVaultTheme.softAccent],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                    
                    marker(size: proxy.size)
                }
            }
            .frame(height: 96)
            
            HStack {
                Text("Reactants")
                Spacer()
                Text("TS")
                Spacer()
                Text("Mg alkoxide")
                Spacer()
                Text("Alcohol")
            }
            .font(.caption2.weight(.semibold))
            .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.84), value: stepIndex)
    }
    
    private func coordinateCurve(size: CGSize, progress: CGFloat = 1) -> Path {
        let full = Path { path in
            path.move(to: CGPoint(x: size.width * 0.04, y: size.height * 0.70))
            path.addCurve(
                to: CGPoint(x: size.width * 0.46, y: size.height * 0.25),
                control1: CGPoint(x: size.width * 0.18, y: size.height * 0.72),
                control2: CGPoint(x: size.width * 0.30, y: size.height * 0.15)
            )
            path.addCurve(
                to: CGPoint(x: size.width * 0.70, y: size.height * 0.62),
                control1: CGPoint(x: size.width * 0.54, y: size.height * 0.36),
                control2: CGPoint(x: size.width * 0.58, y: size.height * 0.66)
            )
            path.addCurve(
                to: CGPoint(x: size.width * 0.96, y: size.height * 0.76),
                control1: CGPoint(x: size.width * 0.80, y: size.height * 0.54),
                control2: CGPoint(x: size.width * 0.88, y: size.height * 0.76)
            )
        }
        
        return full.trimmedPath(from: 0, to: progress)
    }
    
    private func marker(size: CGSize) -> some View {
        let x = size.width * progress
        let y: CGFloat
        
        switch stepIndex {
        case 0:
            y = size.height * 0.70
        case 1:
            y = size.height * 0.55
        case 2:
            y = size.height * 0.27
        case 3:
            y = size.height * 0.62
        default:
            y = size.height * 0.76
        }
        
        return Circle()
            .fill(ChemVaultTheme.accent)
            .frame(width: 16, height: 16)
            .shadow(color: ChemVaultTheme.accent.opacity(0.65), radius: 10)
            .position(x: x, y: y)
    }
}
