import SwiftUI

struct HomeView: View {
    let onStart: () -> Void
    
    @State private var rotateAtom = false
    @State private var glow = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Spacer(minLength: 52)
                
                hero
                    .smoothAppear(delay: 0.05)
                
                missionCard
                    .smoothAppear(delay: 0.16)
                
                routeCards
                    .smoothAppear(delay: 0.27)
                
                startButton
                    .smoothAppear(delay: 0.38)
                
                Spacer(minLength: 32)
            }
            .padding(24)
            .frame(maxWidth: 780)
            .frame(maxWidth: .infinity)
        }
    }
    
    private var hero: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(glow ? 0.28 : 0.14))
                    .frame(width: 132, height: 132)
                    .blur(radius: glow ? 8 : 2)
                
                Circle()
                    .stroke(ChemVaultTheme.accent.opacity(0.25), lineWidth: 1)
                    .frame(width: 146, height: 146)
                    .scaleEffect(glow ? 1.08 : 0.94)
                
                Image(systemName: "atom")
                    .font(.system(size: 76, weight: .medium))
                    .foregroundStyle(ChemVaultTheme.accent)
                    .rotationEffect(.degrees(rotateAtom ? 360 : 0))
            }
            .floating(amount: 5)
            .onAppear {
                withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
                    rotateAtom = true
                }
                
                withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
            
            VStack(spacing: 8) {
                Text("ChemVault")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.text)
                
                Text("Lab Companion")
                    .font(.system(size: 31, weight: .semibold, design: .rounded))
                    .foregroundStyle(ChemVaultTheme.softAccent)
                
                Text("Understand the why before the lab.")
                    .font(.title3)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.top, 4)
            }
        }
    }
    
    private var missionCard: some View {
        PremiumGlassPanel(cornerRadius: 32) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(ChemVaultTheme.accent)
                    
                    Text("Interactive chemistry, not static notes.")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)
                }
                
                Text("Explore safety, electron flow, and experimental data through a guided Grignard reaction experience.")
                    .font(.body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private var routeCards: some View {
        HStack(spacing: 12) {
            HomeRouteCard(
                icon: "shield.lefthalf.filled",
                title: "Safety",
                subtitle: "Dry glassware"
            )
            
            HomeRouteCard(
                icon: "arrow.triangle.branch",
                title: "Mechanism",
                subtitle: "Electron flow"
            )
            
            HomeRouteCard(
                icon: "chart.bar.xaxis",
                title: "Data",
                subtitle: "Yield insight"
            )
        }
    }
    
    private var startButton: some View {
        LiquidGlassButton(
            title: "Enter Lab Mission",
            icon: "play.fill"
        ) {
            onStart()
        }
    }
}

struct HomeRouteCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    @State private var hover = false
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(ChemVaultTheme.accent)
            
            Text(title)
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.text)
            
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .chemGlass(
            cornerRadius: 24,
            tint: ChemVaultTheme.accent.opacity(0.06),
            interactive: true
        )
        .pressableFeedback()
        .scaleEffect(hover ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true).delay(Double.random(in: 0...0.8))) {
                hover = true
            }
        }
    }
}
