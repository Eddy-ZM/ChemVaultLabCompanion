import SwiftUI

struct AppBackgroundView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.030, green: 0.036, blue: 0.055),
                    Color(red: 0.055, green: 0.062, blue: 0.092),
                    Color(red: 0.018, green: 0.022, blue: 0.034)
                ],
                startPoint: animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            
            Circle()
                .fill(ChemVaultTheme.accent.opacity(0.14))
                .frame(width: 330, height: 330)
                .blur(radius: 76)
                .offset(x: animate ? 130 : -120, y: animate ? -230 : -150)
            
            Circle()
                .fill(Color.blue.opacity(0.10))
                .frame(width: 270, height: 270)
                .blur(radius: 82)
                .offset(x: animate ? -150 : 130, y: animate ? 250 : 160)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

struct FloatingModifier: ViewModifier {
    @State private var float = false
    let amount: CGFloat
    
    func body(content: Content) -> some View {
        content
            .offset(y: float ? -amount : amount)
            .onAppear {
                withAnimation(.easeInOut(duration: 3.2).repeatForever(autoreverses: true)) {
                    float = true
                }
            }
    }
}

extension View {
    func floating(amount: CGFloat = 4) -> some View {
        modifier(FloatingModifier(amount: amount))
    }
}
