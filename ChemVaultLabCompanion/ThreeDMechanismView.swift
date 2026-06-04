import SwiftUI
import SceneKit

struct ThreeDMechanismView: UIViewRepresentable {
    let step: Int
    let animationTrigger: Int

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()

        let scene = ThreeDMechanismScene()
        view.scene = scene

        view.backgroundColor = .clear
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = false
        view.antialiasingMode = .multisampling2X
        view.isJitteringEnabled = false
        view.rendersContinuously = false
        view.preferredFramesPerSecond = 60

        context.coordinator.scene = scene
        context.coordinator.view = view

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        guard let scene = context.coordinator.scene else {
            return
        }

        if animationTrigger != context.coordinator.lastTrigger {
            context.coordinator.lastTrigger = animationTrigger

            uiView.rendersContinuously = true

            if step == 1 {
                scene.animateAttackToAlkoxide()
            } else if step == 2 {
                scene.animateWorkupToAlcohol()
            } else if step == 0 {
                scene.resetToInitialState()
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                uiView.rendersContinuously = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        weak var scene: ThreeDMechanismScene?
        weak var view: SCNView?
        var lastTrigger: Int = 0
    }
}
