import SwiftUI
import SceneKit
import UIKit
import QuartzCore

final class ThreeDMechanismScene: SCNScene {

    private let moleculeRoot = SCNNode()
    private let arrowRoot = SCNNode()
    private let effectRoot = SCNNode()

    private var grignardRoot = SCNNode()
    private var carbonylRoot = SCNNode()

    private var grignardCarbon = SCNNode()
    private var magnesium = SCNNode()
    private var bromide = SCNNode()
    private var carbonylCarbon = SCNNode()
    private var carbonylOxygen = SCNNode()

    private var currentStateRoot = SCNNode()

    override init() {
        super.init()
        setupScene()
        resetToInitialState()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupScene()
        resetToInitialState()
    }

    // MARK: - Scene Setup

    private func setupScene() {
        background.contents = UIColor.clear

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 46
        cameraNode.position = SCNVector3(0, 1.15, 8.4)
        cameraNode.eulerAngles = SCNVector3(-0.13, 0, 0)
        rootNode.addChildNode(cameraNode)

        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 560
        rootNode.addChildNode(ambientLight)

        let keyLight = SCNNode()
        keyLight.light = SCNLight()
        keyLight.light?.type = .omni
        keyLight.light?.intensity = 900
        keyLight.position = SCNVector3(-3.6, 4.2, 5.2)
        rootNode.addChildNode(keyLight)

        let rimLight = SCNNode()
        rimLight.light = SCNLight()
        rimLight.light?.type = .omni
        rimLight.light?.intensity = 380
        rimLight.position = SCNVector3(3.6, 2.0, -3.0)
        rootNode.addChildNode(rimLight)

        rootNode.addChildNode(moleculeRoot)
        rootNode.addChildNode(arrowRoot)
        rootNode.addChildNode(effectRoot)
    }

    // MARK: - Public Controls

    func resetToInitialState() {
        clearAll()
        buildInitialReactionMap()
    }

    func animateAttackToAlkoxide() {
        clearArrowsAndEffects()

        let attackCurve = [
            SCNVector3(-2.72, 0.10, 0.25),
            SCNVector3(-1.22, 1.18, 0.30),
            SCNVector3(1.55, 0.08, 0.22)
        ]

        let piCurve = [
            SCNVector3(2.03, 0.55, 0.22),
            SCNVector3(2.35, 1.02, 0.25),
            SCNVector3(2.08, 1.42, 0.22)
        ]

        let attackArrow = animatedCurvedArrow(
            points: attackCurve,
            color: UIColor(red: 1.00, green: 0.80, blue: 0.25, alpha: 1),
            delay: 0.00
        )
        arrowRoot.addChildNode(attackArrow)

        let piArrow = animatedCurvedArrow(
            points: piCurve,
            color: UIColor(red: 1.00, green: 0.92, blue: 0.58, alpha: 1),
            delay: 0.35
        )
        arrowRoot.addChildNode(piArrow)

        spawnElectronParticles(
            points: attackCurve,
            color: UIColor(red: 1.00, green: 0.86, blue: 0.28, alpha: 1),
            delay: 0.10,
            count: 5
        )

        spawnElectronParticles(
            points: piCurve,
            color: UIColor(red: 1.00, green: 0.95, blue: 0.70, alpha: 1),
            delay: 0.45,
            count: 4
        )

        grignardRoot.runAction(
            .sequence([
                .wait(duration: 0.10),
                .moveBy(x: 1.05, y: 0.02, z: 0, duration: 0.92)
            ])
        )

        grignardCarbon.runAction(
            .sequence([
                .wait(duration: 0.18),
                .scale(to: 1.35, duration: 0.20),
                .scale(to: 1.0, duration: 0.20)
            ])
        )

        carbonylCarbon.runAction(
            .sequence([
                .wait(duration: 0.62),
                .scale(to: 1.35, duration: 0.20),
                .scale(to: 1.0, duration: 0.20)
            ])
        )

        carbonylOxygen.runAction(
            .sequence([
                .wait(duration: 0.82),
                .moveBy(x: 0, y: 0.22, z: 0, duration: 0.36)
            ])
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.18) {
            self.transformToAlkoxideVisual()
        }
    }

    func animateWorkupToAlcohol() {
        clearArrowsAndEffects()

        let proton = atom(
            element: "H",
            radius: 0.18,
            color: UIColor.white,
            labelScale: 0.09
        )
        proton.position = SCNVector3(1.52, 2.0, 0.0)
        moleculeRoot.addChildNode(proton)

        let protonHalo = halo(
            color: UIColor.white.withAlphaComponent(0.22),
            radius: 0.36
        )
        proton.addChildNode(protonHalo)

        let protonCurve = [
            SCNVector3(1.34, 1.80, 0.18),
            SCNVector3(0.78, 1.58, 0.22),
            SCNVector3(0.22, 1.34, 0.18)
        ]

        let protonArrow = animatedCurvedArrow(
            points: protonCurve,
            color: UIColor(red: 1.00, green: 0.92, blue: 0.58, alpha: 1),
            delay: 0.02
        )
        arrowRoot.addChildNode(protonArrow)

        spawnElectronParticles(
            points: protonCurve,
            color: UIColor.white,
            delay: 0.12,
            count: 4
        )

        proton.runAction(
            .sequence([
                .wait(duration: 0.12),
                .move(to: SCNVector3(0.55, 1.40, 0), duration: 0.76)
            ])
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.92) {
            self.transformToAlcoholVisual()
        }
    }

    // MARK: - Initial Reaction

    private func buildInitialReactionMap() {
        currentStateRoot = SCNNode()
        moleculeRoot.addChildNode(currentStateRoot)

        buildGrignardFragment()
        buildCarbonylFragment()

        let plus = decorativePlusNode()
        plus.position = SCNVector3(-0.08, 0.02, 0)
        currentStateRoot.addChildNode(plus)
    }

    private func buildGrignardFragment() {
        grignardRoot = SCNNode()
        grignardRoot.position = SCNVector3(-2.55, 0, 0)
        currentStateRoot.addChildNode(grignardRoot)

        grignardCarbon = atom(
            element: "Cδ−",
            radius: 0.30,
            color: UIColor(red: 1.00, green: 0.79, blue: 0.23, alpha: 1),
            labelScale: 0.045
        )
        grignardCarbon.position = SCNVector3(-0.42, 0, 0)
        grignardRoot.addChildNode(grignardCarbon)

        magnesium = atom(
            element: "Mg",
            radius: 0.30,
            color: UIColor(red: 0.42, green: 0.62, blue: 1.00, alpha: 1),
            labelScale: 0.060
        )
        magnesium.position = SCNVector3(0.48, 0, 0)
        grignardRoot.addChildNode(magnesium)

        bromide = atom(
            element: "Br",
            radius: 0.27,
            color: UIColor(red: 0.35, green: 0.80, blue: 0.45, alpha: 1),
            labelScale: 0.060
        )
        bromide.position = SCNVector3(1.22, -0.35, 0)
        grignardRoot.addChildNode(bromide)

        grignardRoot.addChildNode(
            bond(from: grignardCarbon.position, to: magnesium.position, radius: 0.040)
        )
        grignardRoot.addChildNode(
            bond(from: magnesium.position, to: bromide.position, radius: 0.035)
        )

        let nucleophileHalo = halo(
            color: UIColor(red: 1.00, green: 0.80, blue: 0.25, alpha: 0.22),
            radius: 0.54
        )
        grignardCarbon.addChildNode(nucleophileHalo)

        let homo = orbitalCloud(
            color: UIColor(red: 1.00, green: 0.80, blue: 0.25, alpha: 0.18),
            scale: SCNVector3(0.62, 0.30, 0.22),
            position: SCNVector3(-0.23, 0.02, 0.02)
        )
        grignardCarbon.addChildNode(homo)
    }

    private func buildCarbonylFragment() {
        carbonylRoot = SCNNode()
        carbonylRoot.position = SCNVector3(2.10, 0, 0)
        currentStateRoot.addChildNode(carbonylRoot)

        carbonylCarbon = atom(
            element: "Cδ+",
            radius: 0.31,
            color: UIColor(red: 0.20, green: 0.22, blue: 0.25, alpha: 1),
            labelScale: 0.045
        )
        carbonylCarbon.position = SCNVector3(0, 0, 0)
        carbonylRoot.addChildNode(carbonylCarbon)

        carbonylOxygen = atom(
            element: "Oδ−",
            radius: 0.33,
            color: UIColor(red: 0.95, green: 0.18, blue: 0.18, alpha: 1),
            labelScale: 0.045
        )
        carbonylOxygen.position = SCNVector3(0, 1.10, 0)
        carbonylRoot.addChildNode(carbonylOxygen)

        let r1 = atom(
            element: "R",
            radius: 0.23,
            color: UIColor(red: 0.58, green: 0.59, blue: 0.64, alpha: 1),
            labelScale: 0.070
        )
        r1.position = SCNVector3(-0.98, -0.56, 0)
        carbonylRoot.addChildNode(r1)

        let r2 = atom(
            element: "R",
            radius: 0.23,
            color: UIColor(red: 0.58, green: 0.59, blue: 0.64, alpha: 1),
            labelScale: 0.070
        )
        r2.position = SCNVector3(0.98, -0.56, 0)
        carbonylRoot.addChildNode(r2)

        carbonylRoot.addChildNode(doubleBond(from: carbonylCarbon.position, to: carbonylOxygen.position))
        carbonylRoot.addChildNode(bond(from: carbonylCarbon.position, to: r1.position, radius: 0.037))
        carbonylRoot.addChildNode(bond(from: carbonylCarbon.position, to: r2.position, radius: 0.037))

        let electrophileHalo = halo(
            color: UIColor(red: 1.00, green: 0.35, blue: 0.25, alpha: 0.16),
            radius: 0.55
        )
        carbonylCarbon.addChildNode(electrophileHalo)

        let piCloudLeft = orbitalCloud(
            color: UIColor(red: 0.95, green: 0.18, blue: 0.18, alpha: 0.14),
            scale: SCNVector3(0.18, 0.62, 0.16),
            position: SCNVector3(-0.18, 0.55, 0.18)
        )
        carbonylRoot.addChildNode(piCloudLeft)

        let piCloudRight = orbitalCloud(
            color: UIColor(red: 0.95, green: 0.18, blue: 0.18, alpha: 0.14),
            scale: SCNVector3(0.18, 0.62, 0.16),
            position: SCNVector3(0.18, 0.55, -0.18)
        )
        carbonylRoot.addChildNode(piCloudRight)

        addLonePairDots(to: carbonylOxygen, around: SCNVector3(0, 0, 0))
    }

    // MARK: - Alkoxide

    private func transformToAlkoxideVisual() {
        clearAll()

        let root = SCNNode()
        root.opacity = 0
        moleculeRoot.addChildNode(root)

        let c = atom(
            element: "C",
            radius: 0.32,
            color: UIColor(red: 0.20, green: 0.22, blue: 0.25, alpha: 1),
            labelScale: 0.085
        )
        c.position = SCNVector3(0, 0, 0)
        root.addChildNode(c)

        let o = atom(
            element: "O−",
            radius: 0.34,
            color: UIColor(red: 0.95, green: 0.18, blue: 0.18, alpha: 1),
            labelScale: 0.055
        )
        o.position = SCNVector3(0, 1.24, 0)
        root.addChildNode(o)

        let rLeft = atom(
            element: "R",
            radius: 0.24,
            color: UIColor(red: 0.58, green: 0.59, blue: 0.64, alpha: 1),
            labelScale: 0.070
        )
        rLeft.position = SCNVector3(-1.06, -0.46, 0.00)
        root.addChildNode(rLeft)

        let rRight = atom(
            element: "R",
            radius: 0.24,
            color: UIColor(red: 0.58, green: 0.59, blue: 0.64, alpha: 1),
            labelScale: 0.070
        )
        rRight.position = SCNVector3(1.06, -0.46, 0.00)
        root.addChildNode(rRight)

        let newR = atom(
            element: "R",
            radius: 0.27,
            color: UIColor(red: 1.00, green: 0.79, blue: 0.23, alpha: 1),
            labelScale: 0.070
        )
        newR.position = SCNVector3(0, -1.28, 0.30)
        root.addChildNode(newR)

        root.addChildNode(bond(from: c.position, to: o.position, radius: 0.043))
        root.addChildNode(bond(from: c.position, to: rLeft.position, radius: 0.037))
        root.addChildNode(bond(from: c.position, to: rRight.position, radius: 0.037))

        let newBond = bond(from: c.position, to: newR.position, radius: 0.050)
        newBond.scale = SCNVector3(1, 0.05, 1)
        root.addChildNode(newBond)

        let oxygenChargeHalo = halo(
            color: UIColor(red: 1.00, green: 0.22, blue: 0.18, alpha: 0.24),
            radius: 0.62
        )
        o.addChildNode(oxygenChargeHalo)

        addLonePairDots(to: o, around: SCNVector3(0, 0, 0))

        let tetrahedralGlow = orbitalCloud(
            color: UIColor(red: 1.00, green: 0.80, blue: 0.25, alpha: 0.09),
            scale: SCNVector3(1.15, 1.15, 0.85),
            position: SCNVector3(0, -0.10, 0)
        )
        root.addChildNode(tetrahedralGlow)

        root.runAction(.fadeIn(duration: 0.35))
        newBond.runAction(.scale(to: 1.0, duration: 0.50))
    }

    // MARK: - Alcohol

    private func transformToAlcoholVisual() {
        clearAll()

        let root = SCNNode()
        root.opacity = 0
        root.scale = SCNVector3(0.88, 0.88, 0.88)
        moleculeRoot.addChildNode(root)

        let c = atom(
            element: "C",
            radius: 0.32,
            color: UIColor(red: 0.20, green: 0.22, blue: 0.25, alpha: 1),
            labelScale: 0.085
        )
        c.position = SCNVector3(0, 0, 0)
        root.addChildNode(c)

        let o = atom(
            element: "O",
            radius: 0.33,
            color: UIColor(red: 0.95, green: 0.18, blue: 0.18, alpha: 1),
            labelScale: 0.085
        )
        o.position = SCNVector3(0, 1.20, 0)
        root.addChildNode(o)

        let h = atom(
            element: "H",
            radius: 0.18,
            color: UIColor.white,
            labelScale: 0.085
        )
        h.position = SCNVector3(0.70, 1.58, 0)
        root.addChildNode(h)

        let rLeft = atom(
            element: "R",
            radius: 0.24,
            color: UIColor(red: 0.58, green: 0.59, blue: 0.64, alpha: 1),
            labelScale: 0.070
        )
        rLeft.position = SCNVector3(-1.06, -0.46, 0)
        root.addChildNode(rLeft)

        let rRight = atom(
            element: "R",
            radius: 0.24,
            color: UIColor(red: 0.58, green: 0.59, blue: 0.64, alpha: 1),
            labelScale: 0.070
        )
        rRight.position = SCNVector3(1.06, -0.46, 0)
        root.addChildNode(rRight)

        let rNew = atom(
            element: "R",
            radius: 0.27,
            color: UIColor(red: 1.00, green: 0.79, blue: 0.23, alpha: 1),
            labelScale: 0.070
        )
        rNew.position = SCNVector3(0, -1.28, 0.30)
        root.addChildNode(rNew)

        root.addChildNode(bond(from: c.position, to: o.position, radius: 0.043))
        root.addChildNode(bond(from: o.position, to: h.position, radius: 0.032))
        root.addChildNode(bond(from: c.position, to: rLeft.position, radius: 0.037))
        root.addChildNode(bond(from: c.position, to: rRight.position, radius: 0.037))
        root.addChildNode(bond(from: c.position, to: rNew.position, radius: 0.050))

        let productGlow = halo(
            color: UIColor(red: 0.25, green: 0.85, blue: 0.55, alpha: 0.18),
            radius: 1.25
        )
        root.addChildNode(productGlow)

        addLonePairDots(to: o, around: SCNVector3(0, 0, 0))

        root.runAction(
            .group([
                .fadeIn(duration: 0.35),
                .scale(to: 1.0, duration: 0.35)
            ])
        )
    }

    // MARK: - Effects

    private func animatedCurvedArrow(points: [SCNVector3], color: UIColor, delay: Double) -> SCNNode {
        let root = SCNNode()

        guard points.count == 3 else {
            return root
        }

        let samples = quadraticBezierSamples(
            start: points[0],
            control: points[1],
            end: points[2],
            count: 28
        )

        for i in 0..<(samples.count - 1) {
            let segment = bond(from: samples[i], to: samples[i + 1], radius: 0.022)
            segment.geometry?.firstMaterial = glossyMaterial(color: color)
            segment.opacity = 0
            root.addChildNode(segment)

            segment.runAction(
                .sequence([
                    .wait(duration: delay + Double(i) * 0.018),
                    .fadeIn(duration: 0.12)
                ])
            )
        }

        let cone = SCNCone(topRadius: 0, bottomRadius: 0.10, height: 0.23)
        cone.radialSegmentCount = 16
        cone.firstMaterial = glossyMaterial(color: color)

        let head = SCNNode(geometry: cone)
        head.position = points[2]
        head.opacity = 0
        head.look(
            at: points[1],
            up: SCNVector3(0, 1, 0),
            localFront: SCNVector3(0, -1, 0)
        )
        root.addChildNode(head)

        head.runAction(
            .sequence([
                .wait(duration: delay + 0.50),
                .fadeIn(duration: 0.16)
            ])
        )

        return root
    }

    private func spawnElectronParticles(points: [SCNVector3], color: UIColor, delay: Double, count: Int) {
        guard points.count == 3 else { return }

        let samples = quadraticBezierSamples(
            start: points[0],
            control: points[1],
            end: points[2],
            count: 18
        )

        for index in 0..<count {
            let particle = smallSphere(
                radius: 0.045,
                color: color
            )
            particle.position = samples[0]
            particle.opacity = 0
            effectRoot.addChildNode(particle)

            var actions: [SCNAction] = [
                .wait(duration: delay + Double(index) * 0.08),
                .fadeIn(duration: 0.06)
            ]

            for sample in samples.dropFirst() {
                actions.append(.move(to: sample, duration: 0.035))
            }

            actions.append(.fadeOut(duration: 0.10))
            actions.append(.removeFromParentNode())

            particle.runAction(.sequence(actions))
        }
    }

    private func orbitalCloud(color: UIColor, scale: SCNVector3, position: SCNVector3) -> SCNNode {
        let sphere = SCNSphere(radius: 1.0)
        sphere.segmentCount = 24

        let material = transparentMaterial(color: color)
        sphere.firstMaterial = material

        let node = SCNNode(geometry: sphere)
        node.scale = scale
        node.position = position
        node.opacity = 0.85

        return node
    }

    private func halo(color: UIColor, radius: CGFloat) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 24
        sphere.firstMaterial = transparentMaterial(color: color)

        let node = SCNNode(geometry: sphere)
        node.opacity = 0.90

        return node
    }

    private func addLonePairDots(to atomNode: SCNNode, around origin: SCNVector3) {
        let dotColor = UIColor(red: 1.00, green: 0.92, blue: 0.58, alpha: 1)

        let positions = [
            SCNVector3(-0.18, 0.30, 0.18),
            SCNVector3(0.18, 0.30, 0.18),
            SCNVector3(-0.18, 0.30, -0.18),
            SCNVector3(0.18, 0.30, -0.18)
        ]

        for pos in positions {
            let dot = smallSphere(radius: 0.045, color: dotColor)
            dot.position = pos
            atomNode.addChildNode(dot)
        }
    }

    private func decorativePlusNode() -> SCNNode {
        let root = SCNNode()

        let horizontal = SCNBox(width: 0.18, height: 0.035, length: 0.035, chamferRadius: 0.01)
        horizontal.firstMaterial = glossyMaterial(color: UIColor.white.withAlphaComponent(0.65))

        let vertical = SCNBox(width: 0.035, height: 0.18, length: 0.035, chamferRadius: 0.01)
        vertical.firstMaterial = glossyMaterial(color: UIColor.white.withAlphaComponent(0.65))

        root.addChildNode(SCNNode(geometry: horizontal))
        root.addChildNode(SCNNode(geometry: vertical))

        return root
    }

    // MARK: - Geometry Helpers

    private func atom(element: String, radius: CGFloat, color: UIColor, labelScale: Float) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 32
        sphere.firstMaterial = glossyMaterial(color: color)

        let node = SCNNode(geometry: sphere)

        let label = text3D(
            element,
            position: SCNVector3(-0.12, -0.055, Float(radius) + 0.035),
            color: .white,
            scale: labelScale
        )
        node.addChildNode(label)

        return node
    }

    private func smallSphere(radius: CGFloat, color: UIColor) -> SCNNode {
        let sphere = SCNSphere(radius: radius)
        sphere.segmentCount = 12
        sphere.firstMaterial = glossyMaterial(color: color)
        return SCNNode(geometry: sphere)
    }

    private func bond(from start: SCNVector3, to end: SCNVector3, radius: CGFloat) -> SCNNode {
        let vector = end - start
        let length = vector.length

        let cylinder = SCNCylinder(radius: radius, height: CGFloat(length))
        cylinder.radialSegmentCount = 14
        cylinder.firstMaterial = glossyMaterial(
            color: UIColor(red: 0.78, green: 0.80, blue: 0.86, alpha: 1)
        )

        let node = SCNNode(geometry: cylinder)
        node.position = (start + end) / 2
        node.look(
            at: end,
            up: SCNVector3(0, 1, 0),
            localFront: SCNVector3(0, 1, 0)
        )

        return node
    }

    private func doubleBond(from start: SCNVector3, to end: SCNVector3) -> SCNNode {
        let root = SCNNode()
        let offset = SCNVector3(0.078, 0, 0)
        root.addChildNode(bond(from: start + offset, to: end + offset, radius: 0.028))
        root.addChildNode(bond(from: start - offset, to: end - offset, radius: 0.028))
        return root
    }

    private func quadraticBezierSamples(start: SCNVector3, control: SCNVector3, end: SCNVector3, count: Int) -> [SCNVector3] {
        var result: [SCNVector3] = []

        for i in 0..<count {
            let t = Float(i) / Float(count - 1)
            let oneMinusT = 1 - t

            let point =
                start * (oneMinusT * oneMinusT) +
                control * (2 * oneMinusT * t) +
                end * (t * t)

            result.append(point)
        }

        return result
    }

    private func text3D(_ text: String, position: SCNVector3, color: UIColor, scale: Float) -> SCNNode {
        let geometry = SCNText(string: text, extrusionDepth: 0.006)
        geometry.font = UIFont.systemFont(ofSize: 1.0, weight: .bold)
        geometry.firstMaterial = flatMaterial(color: color)
        geometry.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        geometry.isWrapped = false

        let node = SCNNode(geometry: geometry)
        node.position = position
        node.scale = SCNVector3(scale, scale, scale)

        let billboard = SCNBillboardConstraint()
        billboard.freeAxes = [.Y]
        node.constraints = [billboard]

        return node
    }

    // MARK: - Materials

    private func glossyMaterial(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.specular.contents = UIColor.white
        material.shininess = 0.62
        material.lightingModel = .physicallyBased
        material.roughness.contents = 0.28
        material.metalness.contents = 0.02
        return material
    }

    private func transparentMaterial(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = color.withAlphaComponent(0.12)
        material.transparency = CGFloat(color.cgColor.alpha)
        material.blendMode = .alpha
        material.isDoubleSided = true
        material.writesToDepthBuffer = false
        material.readsFromDepthBuffer = true
        return material
    }

    private func flatMaterial(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = color
        material.isDoubleSided = true
        return material
    }

    // MARK: - Clear

    private func clearAll() {
        moleculeRoot.childNodes.forEach { $0.removeFromParentNode() }
        arrowRoot.childNodes.forEach { $0.removeFromParentNode() }
        effectRoot.childNodes.forEach { $0.removeFromParentNode() }
    }

    private func clearArrowsAndEffects() {
        arrowRoot.childNodes.forEach { $0.removeFromParentNode() }
        effectRoot.childNodes.forEach { $0.removeFromParentNode() }
    }
}

// MARK: - SCNVector3 Helpers

fileprivate func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

fileprivate func - (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
    SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
}

fileprivate func * (lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
}

fileprivate func / (lhs: SCNVector3, rhs: Float) -> SCNVector3 {
    SCNVector3(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
}

private extension SCNVector3 {
    var length: Float {
        sqrt(x * x + y * y + z * z)
    }
}
