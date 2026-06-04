import SwiftUI

struct MechanismStory {
    let chapter: String
    let headline: String
    let narrative: String
    let whyItMatters: String
    let labConsequence: String
    let nextAction: String
}

extension CinemaStep {
    var story: MechanismStory {
        switch self {
        case .electronicPreparation:
            return MechanismStory(
                chapter: "Scene 1",
                headline: "Before the reaction begins",
                narrative: "The flask looks quiet, but the key electronic tension is already present. The C–Mg bond in MeMgBr is polarised, and the carbonyl is waiting as an electrophile.",
                whyItMatters: "This explains why the methyl group behaves as a nucleophile without being a free CH₃⁻ ion.",
                labConsequence: "Moisture destroys this polarised reagent before it can attack the carbonyl.",
                nextAction: "Activate the carbonyl"
            )
            
        case .lewisAcidActivation:
            return MechanismStory(
                chapter: "Scene 2",
                headline: "Magnesium organises the attack",
                narrative: "The oxygen lone pair coordinates to MgBr⁺. This is not just decoration — it makes the carbonyl carbon more electrophilic and helps align the reacting partners.",
                whyItMatters: "Grignard additions are often assisted by Lewis acid coordination through magnesium.",
                labConsequence: "Dry ether solvents help stabilise this organomagnesium system.",
                nextAction: "Align the orbitals"
            )
            
        case .orbitalAlignment:
            return MechanismStory(
                chapter: "Scene 3",
                headline: "The orbitals line up",
                narrative: "The nucleophilic C–Mg σ bond donates into the carbonyl π* orbital. The direction of attack is controlled by this HOMO–LUMO interaction.",
                whyItMatters: "This is the electronic reason why attack occurs at the carbonyl carbon, not oxygen.",
                labConsequence: "A successful reaction depends on the reagent approaching the correct electrophilic site.",
                nextAction: "Start electron flow"
            )
            
        case .electronMovement:
            return MechanismStory(
                chapter: "Scene 4",
                headline: "The bond-forming moment",
                narrative: "The methyl group attacks the carbonyl carbon. At the same time, the C=O π electrons move onto oxygen, preventing carbon from exceeding its octet.",
                whyItMatters: "The curved arrows are not decorative; they show conservation of electron pairs.",
                labConsequence: "This step creates the new C–C bond that builds molecular complexity.",
                nextAction: "Reveal the intermediate"
            )
            
        case .magnesiumAlkoxide:
            return MechanismStory(
                chapter: "Scene 5",
                headline: "The product is not alcohol yet",
                narrative: "The immediate product is a magnesium alkoxide. Oxygen carries negative character and remains associated with MgBr⁺.",
                whyItMatters: "Many students incorrectly draw the alcohol too early. The alcohol only appears after workup.",
                labConsequence: "The reaction mixture must be quenched carefully to protonate the alkoxide.",
                nextAction: "Perform acid workup"
            )
            
        case .acidicWorkup:
            return MechanismStory(
                chapter: "Scene 6",
                headline: "Workup reveals the final product",
                narrative: "Acidic workup protonates the alkoxide oxygen, converting the charged magnesium alkoxide into the neutral tertiary alcohol.",
                whyItMatters: "This separates the organometallic reaction step from the proton-transfer step.",
                labConsequence: "Quenching must be controlled because leftover Grignard reagent reacts vigorously with proton sources.",
                nextAction: "Continue to data analysis"
            )
        }
    }
}

struct MechanismStoryPanel: View {
    let step: CinemaStep
    
    var body: some View {
        let story = step.story
        
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(story.chapter)
                    .font(.caption.bold())
                    .foregroundStyle(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(ChemVaultTheme.accent)
                    .clipShape(Capsule())
                
                Spacer()
                
                Text("Lab Story Mode")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.tertiaryText)
            }
            
            Text(story.headline)
                .font(.title3.bold())
                .foregroundStyle(ChemVaultTheme.text)
            
            Text(story.narrative)
                .font(.subheadline)
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack(alignment: .top, spacing: 10) {
                StoryInsightCard(
                    icon: "lightbulb.fill",
                    title: "Why it matters",
                    text: story.whyItMatters,
                    tint: ChemVaultTheme.accent
                )
                
                StoryInsightCard(
                    icon: "flask.fill",
                    title: "Lab consequence",
                    text: story.labConsequence,
                    tint: ChemVaultTheme.softAccent
                )
            }
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
        .animation(.spring(response: 0.55, dampingFraction: 0.84), value: step.rawValue)
    }
}

struct StoryInsightCard: View {
    let icon: String
    let title: String
    let text: String
    let tint: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 7) {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                
                Text(title)
                    .font(.caption.bold())
                    .foregroundStyle(ChemVaultTheme.text)
            }
            
            Text(text)
                .font(.caption)
                .foregroundStyle(ChemVaultTheme.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white.opacity(0.045))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(tint.opacity(0.14), lineWidth: 1)
        )
    }
}

struct MechanismChapterStrip: View {
    let currentStep: CinemaStep
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mechanism Storyboard")
                .font(.headline)
                .foregroundStyle(ChemVaultTheme.text)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(CinemaStep.allCases, id: \.rawValue) { step in
                        chapterCard(step: step)
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
    
    private func chapterCard(step: CinemaStep) -> some View {
        let active = step.rawValue == currentStep.rawValue
        let completed = step.rawValue < currentStep.rawValue
        
        return VStack(alignment: .leading, spacing: 6) {
            ZStack {
                Circle()
                    .fill(active || completed ? ChemVaultTheme.accent : .white.opacity(0.10))
                    .frame(width: 28, height: 28)
                
                Text("\(step.rawValue + 1)")
                    .font(.caption.bold())
                    .foregroundStyle(active || completed ? .black : ChemVaultTheme.secondaryText)
            }
            
            Text(step.shortTitle)
                .font(.caption.bold())
                .foregroundStyle(active ? ChemVaultTheme.text : ChemVaultTheme.secondaryText)
            
            Text(step.keyFormula)
                .font(.caption2)
                .foregroundStyle(ChemVaultTheme.tertiaryText)
                .lineLimit(2)
        }
        .frame(width: 116, height: 104, alignment: .topLeading)
        .padding(10)
        .background(active ? ChemVaultTheme.accent.opacity(0.11) : .white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(active ? ChemVaultTheme.accent.opacity(0.45) : .white.opacity(0.06), lineWidth: 1)
        )
    }
}

struct MechanismEvidenceStrip: View {
    let step: CinemaStep

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(ChemVaultTheme.accent.opacity(0.16))
                    .frame(width: 42, height: 42)

                Image(systemName: "doc.text.magnifyingglass")
                    .font(.headline)
                    .foregroundStyle(ChemVaultTheme.accent)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 8) {
                    Text("Evidence collected")
                        .font(.caption.bold())
                        .foregroundStyle(ChemVaultTheme.accent)

                    Text(step.story.chapter)
                        .font(.caption2.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(ChemVaultTheme.accent)
                        .clipShape(Capsule())
                }

                Text(step.story.whyItMatters)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .background(.white.opacity(0.055))
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(ChemVaultTheme.accent.opacity(0.16), lineWidth: 1)
        )
        .animation(.spring(response: 0.55, dampingFraction: 0.84), value: step.rawValue)
    }
}
