import SwiftUI

struct ReflectionView: View {
    let onRestart: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer(minLength: 40)
                
                completionHero
                    .smoothAppear(delay: 0.04)
                
                learningSummary
                    .smoothAppear(delay: 0.18)
                
                projectStatement
                    .smoothAppear(delay: 0.32)
                
                PrimaryButton("Restart Lab", icon: "arrow.counterclockwise") {
                    onRestart()
                }
                .smoothAppear(delay: 0.46)
                
                Spacer(minLength: 30)
            }
            .padding(24)
            .frame(maxWidth: 760)
            .frame(maxWidth: .infinity)
        }
    }
    
    private var completionHero: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(ChemVaultTheme.accent)
            }
            
            Text("Lab Complete")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundStyle(ChemVaultTheme.text)
            
            Text("You are now better prepared to understand a Grignard reaction before entering the lab.")
                .font(.title3)
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
    }
    
    private var learningSummary: some View {
        ChemCard {
            VStack(alignment: .leading, spacing: 18) {
                Text("What You Learned")
                    .font(.title2.bold())
                    .foregroundStyle(ChemVaultTheme.text)
                
                ReflectionRow(
                    icon: "shield.lefthalf.filled",
                    title: "Safety",
                    text: "Dry conditions matter because water destroys the Grignard reagent."
                )
                
                ReflectionRow(
                    icon: "arrow.triangle.branch",
                    title: "Mechanism",
                    text: "The carbon nucleophile attacks the carbonyl carbon and forms an alkoxide."
                )
                
                ReflectionRow(
                    icon: "chart.bar.xaxis",
                    title: "Data",
                    text: "Percentage yield helps diagnose experimental quality and possible sources of error."
                )
            }
        }
    }
    
    private var projectStatement: some View {
        ChemCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(ChemVaultTheme.accent)
                    
                    Text("ChemVault Philosophy")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)
                }
                
                Text("Chemistry is not just about following instructions. It is about understanding why every condition, reagent, and observation matters.")
                    .font(.body)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ReflectionRow: View {
    let icon: String
    let title: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .foregroundStyle(ChemVaultTheme.accent)
                .font(.title3)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.text)
                
                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
            }
        }
    }
}
