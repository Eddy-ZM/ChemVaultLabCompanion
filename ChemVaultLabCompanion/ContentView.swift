import SwiftUI

struct ContentView: View {
    @State private var stage: Int = 0
    @State private var transitionID = UUID()
    @State private var caseFile = LabCaseFile()

    var body: some View {
        ZStack {
            AppBackgroundView()

            Group {
                switch stage {
                case 0:
                    CinematicLaunchView {
                        goToStage(1)
                    }
                case 1:
                    HomeView(caseFile: caseFile) {
                        goToStage(2)
                    }
                case 2:
                    LabMissionView(caseFile: caseFile) {
                        goToStage(3)
                    }
                case 3:
                    SafetyScanView { diagnosis in
                        caseFile.safetyDiagnosis = diagnosis
                        goToStage(4)
                    }
                case 4:
                    MechanismExplorerView(caseFile: caseFile) {
                        caseFile.reviewedMechanismProofIDs = Set(MechanismProof.allCases.map(\.rawValue))
                        goToStage(5)
                    }
                case 5:
                    MechanismChallengeView { result in
                        caseFile.challengeResult = result
                        goToStage(6)
                    }
                case 6:
                    DataCheckView(caseFile: caseFile) { record in
                        caseFile.yieldRecord = record
                        goToStage(7)
                    }
                default:
                    LabNotebookSummaryView(caseFile: caseFile) {
                        caseFile = LabCaseFile()
                        goToStage(0)
                    }
                }
            }
            .id(transitionID)
            .transition(
                .asymmetric(
                    insertion: .opacity
                        .combined(with: .scale(scale: 0.965))
                        .combined(with: .move(edge: .trailing)),
                    removal: .opacity
                        .combined(with: .scale(scale: 1.025))
                        .combined(with: .move(edge: .leading))
                )
            )
        }
    }

    private func goToStage(_ newStage: Int) {
        withAnimation(AppMotion.smooth) {
            stage = newStage
            transitionID = UUID()
        }
    }
}

#Preview {
    ContentView()
}
