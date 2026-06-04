import SwiftUI

struct MechanismHUDView: View {
    let step: Int
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                statusChip(
                    icon: "bolt.fill",
                    title: "Nucleophile",
                    value: step == 0 ? "Ready" : "Bond formed",
                    active: step >= 0
                )
                
                statusChip(
                    icon: "arrow.triangle.branch",
                    title: "π Bond",
                    value: step >= 1 ? "Moved to O" : "Polarised",
                    active: step >= 1
                )
            }
            
            HStack(spacing: 10) {
                statusChip(
                    icon: "minus.circle.fill",
                    title: "Oxygen",
                    value: step >= 1 ? "O⁻" : "δ−",
                    active: step >= 1
                )
                
                statusChip(
                    icon: "drop.fill",
                    title: "Workup",
                    value: step >= 2 ? "Protonated" : "Waiting",
                    active: step >= 2
                )
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: step)
    }
    
    private func statusChip(icon: String, title: String, value: String, active: Bool) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(active ? ChemVaultTheme.accent : ChemVaultTheme.tertiaryText)
                .frame(width: 18)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
                
                Text(value)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(active ? ChemVaultTheme.text : ChemVaultTheme.secondaryText)
            }
            
            Spacer()
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(active ? 0.075 : 0.035))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(active ? ChemVaultTheme.accent.opacity(0.22) : .white.opacity(0.05), lineWidth: 1)
        )
    }
}
