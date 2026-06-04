import SwiftUI

struct MechanismFocusPanel: View {
    let step: CinemaStep
    let focusMode: FocusMode
    let onSelect: (FocusMode) -> Void
    
    var body: some View {
        PremiumGlassPanel(cornerRadius: 28) {
            VStack(alignment: .leading, spacing: 16) {
                header
                
                modeSelector
                
                explanationBlock
                
                takeawaysBlock
            }
        }
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Focus Mode")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)
                
                Text("Choose what the mechanism should explain.")
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
            }
            
            Spacer()
            
            Text(focusMode.subtitle)
                .font(.caption.bold())
                .foregroundStyle(.black)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(ChemVaultTheme.accent)
                .clipShape(Capsule())
        }
    }
    
    private var modeSelector: some View {
        HStack(spacing: 8) {
            ForEach(FocusMode.allCases, id: \.self) { mode in
                Button {
                    onSelect(mode)
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: mode.icon)
                            .font(.headline)
                        
                        Text(mode.rawValue)
                            .font(.caption2.bold())
                            .minimumScaleFactor(0.75)
                    }
                    .foregroundStyle(focusMode == mode ? .black : ChemVaultTheme.text)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 11)
                    .background(focusMode == mode ? ChemVaultTheme.accent : .white.opacity(0.055))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(focusMode == mode ? .white.opacity(0.35) : .white.opacity(0.06), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var explanationBlock: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(0.14))
                    .frame(width: 38, height: 38)
                
                Image(systemName: focusMode.icon)
                    .foregroundStyle(ChemVaultTheme.accent)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(focusMode.rawValue) focus for \(step.shortTitle)")
                    .font(.subheadline.bold())
                    .foregroundStyle(ChemVaultTheme.text)
                
                Text(step.focusText(for: focusMode))
                    .font(.caption)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer()
        }
        .padding(12)
        .background(.white.opacity(0.045))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.07), lineWidth: 1)
        )
    }
    
    private var takeawaysBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What to notice")
                .font(.caption.bold())
                .foregroundStyle(ChemVaultTheme.accent)
            
            ForEach(step.focusTakeaways(for: focusMode), id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundStyle(ChemVaultTheme.success)
                    
                    Text(item)
                        .font(.caption)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(12)
        .background(.white.opacity(0.035))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
