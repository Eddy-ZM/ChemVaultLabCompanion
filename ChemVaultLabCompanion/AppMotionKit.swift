import SwiftUI

enum AppMotion {
    static let smooth = Animation.spring(response: 0.55, dampingFraction: 0.86)
    static let soft = Animation.spring(response: 0.72, dampingFraction: 0.88)
    static let quick = Animation.spring(response: 0.32, dampingFraction: 0.78)
}

struct SmoothAppearModifier: ViewModifier {
    let delay: Double
    
    @State private var appeared = false
    
    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .blur(radius: appeared ? 0 : 8)
            .offset(y: appeared ? 0 : 22)
            .scaleEffect(appeared ? 1 : 0.97)
            .onAppear {
                withAnimation(AppMotion.soft.delay(delay)) {
                    appeared = true
                }
            }
    }
}

extension View {
    func smoothAppear(delay: Double = 0) -> some View {
        modifier(SmoothAppearModifier(delay: delay))
    }
}

struct PressableModifier: ViewModifier {
    @State private var pressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(pressed ? 0.975 : 1.0)
            .brightness(pressed ? 0.025 : 0)
            .onLongPressGesture(
                minimumDuration: 0.01,
                maximumDistance: 50,
                pressing: { isPressing in
                    withAnimation(AppMotion.quick) {
                        pressed = isPressing
                    }
                },
                perform: {}
            )
    }
}

extension View {
    func pressableFeedback() -> some View {
        modifier(PressableModifier())
    }
}
