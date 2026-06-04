import SwiftUI

extension View {
    func chemGlass(
        cornerRadius: CGFloat = 28,
        tint: Color = ChemVaultTheme.accent.opacity(0.08),
        interactive: Bool = false
    ) -> some View {
        self
            .background(
                .ultraThinMaterial,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(tint.opacity(interactive ? 0.75 : 0.55))
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(interactive ? 0.38 : 0.32),
                                .white.opacity(0.06),
                                ChemVaultTheme.accent.opacity(interactive ? 0.22 : 0.16)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

struct PremiumGlassPanel<Content: View>: View {
    let cornerRadius: CGFloat
    let content: Content
    
    init(cornerRadius: CGFloat = 30, @ViewBuilder content: () -> Content) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .chemGlass(cornerRadius: cornerRadius)
            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)
            .shadow(color: ChemVaultTheme.accent.opacity(0.08), radius: 16, x: 0, y: 8)
    }
}

struct LiquidGlassButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    @State private var pressed = false
    @State private var glow = false
    
    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.62)) {
                pressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.72)) {
                    pressed = false
                }
                action()
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: [
                        ChemVaultTheme.accent,
                        ChemVaultTheme.softAccent
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.45), lineWidth: 1)
            )
            .scaleEffect(pressed ? 0.965 : 1.0)
            .shadow(
                color: ChemVaultTheme.accent.opacity(glow ? 0.30 : 0.14),
                radius: glow ? 20 : 10,
                x: 0,
                y: glow ? 10 : 5
            )
        }
        .buttonStyle(.plain)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }
}
