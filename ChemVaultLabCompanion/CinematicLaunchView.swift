import SwiftUI

struct CinematicLaunchView: View {
    let onEnter: () -> Void
    
    @State private var phase = 0
    @State private var glow = false
    @State private var moleculeDrift = false
    @State private var showEnterButton = false
    
    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.width < 430
            
            ZStack {
                launchBackground
                
                MolecularBlueprintField()
                    .opacity(0.34)
                
                VStack(spacing: compact ? 26 : 34) {
                    Spacer()
                    
                    logoScene(compact: compact)
                        .opacity(phase >= 0 ? 1 : 0)
                        .offset(y: phase >= 0 ? 0 : 20)
                    
                    cinematicText(compact: compact)
                        .opacity(phase >= 1 ? 1 : 0)
                        .offset(y: phase >= 1 ? 0 : 20)
                    
                    labSystemPreview(compact: compact)
                        .opacity(phase >= 2 ? 1 : 0)
                        .offset(y: phase >= 2 ? 0 : 18)
                    
                    if showEnterButton {
                        LiquidGlassButton(
                            title: "Enter ChemVault Lab",
                            icon: "sparkles"
                        ) {
                            onEnter()
                        }
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                    
                    Spacer()
                    
                    if !showEnterButton {
                        Text("Preparing molecular simulation…")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(ChemVaultTheme.tertiaryText)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.horizontal, compact ? 22 : 36)
                .frame(maxWidth: 760)
                .frame(maxWidth: .infinity)
            }
            .onAppear {
                runOpeningSequence()
                
                withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                    glow = true
                }
                
                withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                    moleculeDrift = true
                }
            }
        }
    }
    
    private var launchBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.015, green: 0.018, blue: 0.030),
                    Color(red: 0.030, green: 0.038, blue: 0.060),
                    Color(red: 0.010, green: 0.012, blue: 0.020)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(ChemVaultTheme.accent.opacity(glow ? 0.20 : 0.08))
                .frame(width: glow ? 420 : 320, height: glow ? 420 : 320)
                .blur(radius: 90)
                .offset(x: -150, y: -220)
            
            Circle()
                .fill(Color.red.opacity(glow ? 0.12 : 0.04))
                .frame(width: glow ? 320 : 260, height: glow ? 320 : 260)
                .blur(radius: 80)
                .offset(x: 160, y: 240)
        }
    }
    
    private func logoScene(compact: Bool) -> some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(ChemVaultTheme.accent.opacity(0.22), lineWidth: 1)
                    .frame(width: compact ? 150 : 190, height: compact ? 150 : 190)
                    .scaleEffect(glow ? 1.08 : 0.96)
                
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(glow ? 0.16 : 0.08))
                    .frame(width: compact ? 118 : 150, height: compact ? 118 : 150)
                    .blur(radius: 8)
                
                Image(systemName: "atom")
                    .font(.system(size: compact ? 76 : 96, weight: .medium))
                    .foregroundStyle(ChemVaultTheme.accent)
                    .rotationEffect(.degrees(moleculeDrift ? 360 : 0))
                    .animation(.linear(duration: 18).repeatForever(autoreverses: false), value: moleculeDrift)
            }
            
            VStack(spacing: 6) {
                Text("ChemVault")
                    .font(.system(size: compact ? 48 : 64, weight: .bold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.text)
                
                Text("Lab Companion")
                    .font(.system(size: compact ? 24 : 32, weight: .semibold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.softAccent)
            }
        }
    }
    
    private func cinematicText(compact: Bool) -> some View {
        VStack(spacing: 12) {
            Text("Every successful reaction begins before the first drop is added.")
                .font(.system(size: compact ? 22 : 30, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.text)
                .multilineTextAlignment(.center)
            
            Text("Simulate the invisible chemistry behind a Grignard addition: dry conditions, Lewis acid activation, electron flow, and experimental data.")
                .font(compact ? .subheadline : .title3)
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private func labSystemPreview(compact: Bool) -> some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                LaunchStatusChip(
                    icon: "drop.triangle",
                    title: "Dry system",
                    value: "Required"
                )
                
                LaunchStatusChip(
                    icon: "plusminus",
                    title: "C–Mg bond",
                    value: "Polarised"
                )
            }
            
            HStack(spacing: 10) {
                LaunchStatusChip(
                    icon: "arrow.triangle.branch",
                    title: "Electron flow",
                    value: "Guided"
                )
                
                LaunchStatusChip(
                    icon: "chart.xyaxis.line",
                    title: "Yield",
                    value: "Interpreted"
                )
            }
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(.white.opacity(0.10), lineWidth: 1)
        )
    }
    
    private func runOpeningSequence() {
        phase = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
            withAnimation(.spring(response: 0.75, dampingFraction: 0.84)) {
                phase = 1
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.20) {
            withAnimation(.spring(response: 0.75, dampingFraction: 0.84)) {
                phase = 2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.10) {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.82)) {
                showEnterButton = true
            }
        }
    }
}

struct LaunchStatusChip: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 9) {
            Image(systemName: icon)
                .foregroundStyle(ChemVaultTheme.accent)
                .frame(width: 18)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                
                Text(value)
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.text)
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.07), lineWidth: 1)
        )
    }
}
