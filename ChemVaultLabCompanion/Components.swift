import SwiftUI

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                }
                
                Text(title)
                    .font(.headline)
            }
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(ChemVaultTheme.accent)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: ChemVaultTheme.accent.opacity(0.25), radius: 16, x: 0, y: 8)
        }
        .accessibilityLabel(title)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.text)
                .frame(maxWidth: .infinity)
                .padding()
                .background(ChemVaultTheme.elevatedCard)
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
    }
}

struct InfoBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(ChemVaultTheme.accent)
            
            Text(text)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.text)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(ChemVaultTheme.card)
        .clipShape(Capsule())
    }
}

struct ChemCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: ChemVaultTheme.cornerRadius)
                    .fill(ChemVaultTheme.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: ChemVaultTheme.cornerRadius)
                            .stroke(.white.opacity(0.06), lineWidth: 1)
                    )
            )
    }
}
