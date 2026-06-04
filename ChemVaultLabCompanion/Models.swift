import Foundation

struct SafetyCard: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

struct MechanismStep {
    let title: String
    let explanation: String
}
