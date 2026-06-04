import SwiftUI

struct ProgressHeaderView: View {
    let currentStep: Int
    let title: String
    let subtitle: String
    
    private let totalSteps = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Step \(currentStep) of \(totalSteps)")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.accent)
                
                Spacer()
                
                Text("\(Int(Double(currentStep) / Double(totalSteps) * 100))%")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
            }
            
            ProgressView(value: Double(currentStep), total: Double(totalSteps))
                .tint(ChemVaultTheme.accent)
                .scaleEffect(x: 1, y: 1.6, anchor: .center)
            
            Text(title)
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.text)
            
            Text(subtitle)
                .font(.body)
                .foregroundStyle(ChemVaultTheme.secondaryText)
        }
    }
}
