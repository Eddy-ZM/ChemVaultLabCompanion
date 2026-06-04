import SwiftUI

struct MolecularBlueprintField: View {
    @State private var drift = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<10, id: \.self) { index in
                    BlueprintMolecule(index: index)
                        .position(
                            x: proxy.size.width * xPosition(for: index),
                            y: proxy.size.height * yPosition(for: index)
                        )
                        .offset(
                            x: drift ? CGFloat(index % 3 - 1) * 18 : CGFloat(index % 2) * -14,
                            y: drift ? CGFloat(index % 4 - 2) * 14 : CGFloat(index % 3) * -10
                        )
                        .opacity(index % 2 == 0 ? 0.48 : 0.30)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true)) {
                    drift = true
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private func xPosition(for index: Int) -> CGFloat {
        let values: [CGFloat] = [0.10, 0.82, 0.24, 0.66, 0.46, 0.92, 0.15, 0.75, 0.38, 0.58]
        return values[index % values.count]
    }
    
    private func yPosition(for index: Int) -> CGFloat {
        let values: [CGFloat] = [0.12, 0.18, 0.34, 0.42, 0.58, 0.70, 0.82, 0.88, 0.26, 0.76]
        return values[index % values.count]
    }
}

struct BlueprintMolecule: View {
    let index: Int
    
    var body: some View {
        ZStack {
            blueprintBond(length: 58, angle: -28)
            blueprintBond(length: 58, angle: 28)
            blueprintBond(length: 58, angle: 90)
            
            Circle()
                .stroke(ChemVaultTheme.accent.opacity(0.45), lineWidth: 1.2)
                .frame(width: 26, height: 26)
            
            Circle()
                .stroke(Color.red.opacity(0.34), lineWidth: 1.2)
                .frame(width: 22, height: 22)
                .offset(y: -46)
            
            Text(index % 2 == 0 ? "C=O" : "MgBr")
                .font(.caption2.bold())
                .foregroundStyle(.white.opacity(0.38))
                .offset(y: 46)
        }
        .rotationEffect(.degrees(Double(index) * 23))
        .scaleEffect(index % 3 == 0 ? 1.12 : 0.88)
    }
    
    private func blueprintBond(length: CGFloat, angle: Double) -> some View {
        Capsule()
            .fill(.white.opacity(0.18))
            .frame(width: length, height: 2)
            .rotationEffect(.degrees(angle))
    }
}
