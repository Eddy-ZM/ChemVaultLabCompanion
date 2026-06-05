import Testing
@testable import ChemVaultLabCompanion

struct ChemistryMotionPresetTests {
    @Test func livingChemistryAnimationsStayOneShotAndLightweight() {
        for preset in ChemistryMotionPreset.allCases {
            #expect(preset.repeats == false)
            #expect(preset.duration <= 1.6)
            #expect(preset.maximumTravel <= 160)
        }
    }

    @Test func orbitalPresetMatchesLaunchAtomLanguage() {
        #expect(ChemistryMotionPreset.orbital.rotationDegrees == 360)
        #expect(ChemistryMotionPreset.orbital.duration >= 1.0)
    }

    @Test func scannerPresetMovesAcrossTheFullComponent() {
        #expect(ChemistryMotionPreset.scanner.maximumTravel == 140)
        #expect(ChemistryMotionPreset.scanner.rotationDegrees == 0)
    }
}
