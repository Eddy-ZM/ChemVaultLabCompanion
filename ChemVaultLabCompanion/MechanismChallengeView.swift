import SwiftUI

struct MechanismChallengeView: View {
    let onComplete: (MechanismChallengeResult) -> Void
    
    @State private var currentQuestion = 0
    @State private var selectedAnswer: Int? = nil
    @State private var correctAnswers = 0
    @State private var showFeedback = false
    @State private var completed = false
    @State private var glow = false
    @State private var missedMisconceptions: [MechanismMisconception] = []
    
    private let questions: [MechanismChallengeQuestion] = [
        MechanismChallengeQuestion(
            title: "Identify the nucleophile",
            prompt: "In MeMgBr, which part behaves as the nucleophilic site?",
            visualMode: .nucleophile,
            answers: [
                "The methyl carbon attached to Mg",
                "The bromide ion",
                "The oxygen of acetone",
                "The carbonyl oxygen"
            ],
            correctIndex: 0,
            misconception: .reactiveSite,
            explanation: "The C–Mg bond is strongly polarised toward carbon, giving the methyl carbon carbanion-like nucleophilic character."
        ),
        MechanismChallengeQuestion(
            title: "Choose the electron flow",
            prompt: "Which curved arrow best describes the key addition step?",
            visualMode: .electronFlow,
            answers: [
                "Oxygen attacks MgBr",
                "CH₃ attacks the carbonyl carbon, while π(C=O) moves to oxygen",
                "Bromide attacks the carbonyl carbon",
                "The carbonyl oxygen attacks CH₃"
            ],
            correctIndex: 1,
            misconception: .electronFlow,
            explanation: "The nucleophilic methyl group attacks the electrophilic carbonyl carbon, and the C=O π electrons move onto oxygen."
        ),
        MechanismChallengeQuestion(
            title: "Predict the intermediate",
            prompt: "What is formed immediately after nucleophilic addition, before workup?",
            visualMode: .intermediate,
            answers: [
                "A neutral tertiary alcohol",
                "A carboxylic acid",
                "A magnesium alkoxide",
                "An alkene"
            ],
            correctIndex: 2,
            misconception: .workupTiming,
            explanation: "The immediate product is a tetrahedral magnesium alkoxide. The neutral alcohol only appears after acidic workup."
        ),
        MechanismChallengeQuestion(
            title: "Explain acid workup",
            prompt: "Why is acidic workup required at the end?",
            visualMode: .workup,
            answers: [
                "To protonate the alkoxide oxygen",
                "To make the Grignard reagent more reactive",
                "To remove the carbonyl group",
                "To convert MgBr into a nucleophile"
            ],
            correctIndex: 0,
            misconception: .protonation,
            explanation: "Acidic workup protonates the alkoxide oxygen, converting R₃C–O⁻ into R₃C–OH."
        )
    ]
    
    private var question: MechanismChallengeQuestion {
        questions[currentQuestion]
    }
    
    var body: some View {
        GeometryReader { geometry in
            let compact = geometry.size.width < 430
            
            ZStack {
                AppBackgroundView()
                
                ScrollView {
                    VStack(spacing: compact ? 16 : 22) {
                        header(compact: compact)
                            .smoothAppear(delay: 0.04)
                        
                        challengeProgress(compact: compact)
                            .smoothAppear(delay: 0.10)
                        
                        challengeCard(compact: compact)
                            .smoothAppear(delay: 0.16)
                        
                        answerSection(compact: compact)
                            .smoothAppear(delay: 0.24)
                        
                        if showFeedback {
                            feedbackCard(compact: compact)
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                        }
                        
                        Spacer(minLength: 112)
                    }
                    .padding(.horizontal, compact ? 14 : 24)
                    .padding(.top, compact ? 14 : 24)
                    .frame(maxWidth: 860)
                    .frame(maxWidth: .infinity)
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomActionBar(compact: compact)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    glow = true
                }
            }
        }
    }
    
    private func header(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 24 : 34) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(ChemVaultTheme.accent.opacity(glow ? 0.22 : 0.12))
                        .frame(width: compact ? 46 : 64, height: compact ? 46 : 64)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: compact ? 23 : 32, weight: .semibold))
                        .foregroundStyle(ChemVaultTheme.accent)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Mechanism Challenge")
                        .font(.system(size: compact ? 22 : 31, weight: .bold, design: .rounded))
                        .foregroundStyle(ChemVaultTheme.text)
                    
                    Text("Test whether you can reason through the Grignard mechanism, not just watch it.")
                        .font(compact ? .caption : .subheadline)
                        .foregroundStyle(ChemVaultTheme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
        }
    }
    
    private func challengeProgress(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 22 : 28) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Challenge Progress")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)
                    
                    Spacer()
                    
                    Text("\(currentQuestion + 1)/\(questions.count)")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(ChemVaultTheme.accent)
                        .clipShape(Capsule())
                }
                
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.08))
                            .frame(height: 8)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [ChemVaultTheme.accent, ChemVaultTheme.softAccent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: proxy.size.width * CGFloat(currentQuestion + 1) / CGFloat(questions.count),
                                height: 8
                            )
                    }
                }
                .frame(height: 10)
            }
        }
    }
    
    private func challengeCard(compact: Bool) -> some View {
        PremiumGlassPanel(cornerRadius: compact ? 26 : 34) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(question.title, systemImage: question.visualMode.icon)
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)
                    
                    Spacer()
                    
                    Text("Interactive")
                        .font(.caption.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(ChemVaultTheme.accent)
                        .clipShape(Capsule())
                }
                
                ChallengeVisual(mode: question.visualMode)
                    .frame(height: compact ? 210 : 270)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(.white.opacity(0.08), lineWidth: 1)
                    )
                
                Text(question.prompt)
                    .font(compact ? .subheadline.bold() : .title3.bold())
                    .foregroundStyle(ChemVaultTheme.text)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private func answerSection(compact: Bool) -> some View {
        VStack(spacing: 10) {
            ForEach(question.answers.indices, id: \.self) { index in
                AnswerOptionCard(
                    text: question.answers[index],
                    index: index,
                    selected: selectedAnswer == index,
                    isCorrect: showFeedback && index == question.correctIndex,
                    isWrong: showFeedback && selectedAnswer == index && index != question.correctIndex
                ) {
                    guard !showFeedback else { return }
                    
                    withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                        selectedAnswer = index
                    }
                }
            }
        }
    }
    
    private func feedbackCard(compact: Bool) -> some View {
        let correct = selectedAnswer == question.correctIndex
        
        return PremiumGlassPanel(cornerRadius: compact ? 22 : 28) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(correct ? ChemVaultTheme.success : ChemVaultTheme.warning)
                    
                    Text(correct ? "Correct reasoning" : "Not quite")
                        .font(.headline)
                        .foregroundStyle(ChemVaultTheme.text)
                    
                    Spacer()
                }
                
                Text(question.explanation)
                    .font(.subheadline)
                    .foregroundStyle(ChemVaultTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private func bottomActionBar(compact: Bool) -> some View {
        VStack(spacing: 8) {
            LiquidGlassButton(
                title: bottomButtonTitle,
                icon: bottomButtonIcon
            ) {
                handleBottomAction()
            }
            
            Text(bottomHint)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(ChemVaultTheme.tertiaryText)
        }
        .padding(.horizontal, compact ? 14 : 24)
        .padding(.top, 10)
        .padding(.bottom, compact ? 8 : 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    ChemVaultTheme.background.opacity(0.10),
                                    ChemVaultTheme.background.opacity(0.72)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
                .ignoresSafeArea()
        )
    }
    
    private var bottomButtonTitle: String {
        if completed {
            return "Continue to Data Check"
        }
        
        if showFeedback {
            return currentQuestion == questions.count - 1 ? "Finish Challenge" : "Next Challenge"
        }
        
        return "Check Answer"
    }
    
    private var bottomButtonIcon: String {
        if completed {
            return "arrow.right"
        }
        return showFeedback ? "arrow.right" : "checkmark"
    }
    
    private var bottomHint: String {
        if completed {
            return "You completed the mechanism reasoning challenge."
        }
        if showFeedback {
            return "Review the explanation before continuing."
        }
        return "Choose the best answer, then check your reasoning."
    }
    
    private func handleBottomAction() {
        if completed {
            onComplete(
                MechanismChallengeResult(
                    correctAnswers: correctAnswers,
                    totalQuestions: questions.count,
                    misconceptions: missedMisconceptions
                )
            )
            return
        }
        
        if showFeedback {
            if currentQuestion == questions.count - 1 {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                    completed = true
                }
            } else {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                    currentQuestion += 1
                    selectedAnswer = nil
                    showFeedback = false
                }
            }
        } else {
            guard let selectedAnswer else { return }
            
            if selectedAnswer == question.correctIndex {
                correctAnswers += 1
            } else if !missedMisconceptions.contains(question.misconception) {
                missedMisconceptions.append(question.misconception)
            }
            
            withAnimation(.spring(response: 0.45, dampingFraction: 0.82)) {
                showFeedback = true
            }
        }
    }
}

struct MechanismChallengeQuestion {
    let title: String
    let prompt: String
    let visualMode: ChallengeVisualMode
    let answers: [String]
    let correctIndex: Int
    let misconception: MechanismMisconception
    let explanation: String
}

enum ChallengeVisualMode {
    case nucleophile
    case electronFlow
    case intermediate
    case workup
    
    var icon: String {
        switch self {
        case .nucleophile:
            return "plusminus"
        case .electronFlow:
            return "arrow.triangle.branch"
        case .intermediate:
            return "minus.circle.fill"
        case .workup:
            return "drop.fill"
        }
    }
}

struct AnswerOptionCard: View {
    let text: String
    let index: Int
    let selected: Bool
    let isCorrect: Bool
    let isWrong: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(circleFill)
                        .frame(width: 34, height: 34)
                    
                    Text(String(UnicodeScalar(65 + index)!))
                        .font(.caption.bold())
                        .foregroundStyle(selected || isCorrect ? .black : ChemVaultTheme.text)
                }
                
                Text(text)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ChemVaultTheme.text)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                if isCorrect {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(ChemVaultTheme.success)
                } else if isWrong {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(ChemVaultTheme.warning)
                }
            }
            .padding()
            .background(cardFill)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .pressableFeedback()
    }
    
    private var circleFill: Color {
        if isCorrect {
            return ChemVaultTheme.success
        }
        if isWrong {
            return ChemVaultTheme.warning
        }
        if selected {
            return ChemVaultTheme.accent
        }
        return .white.opacity(0.08)
    }
    
    private var cardFill: Color {
        if isCorrect {
            return ChemVaultTheme.success.opacity(0.12)
        }
        if isWrong {
            return ChemVaultTheme.warning.opacity(0.12)
        }
        if selected {
            return ChemVaultTheme.accent.opacity(0.10)
        }
        return .white.opacity(0.045)
    }
    
    private var borderColor: Color {
        if isCorrect {
            return ChemVaultTheme.success.opacity(0.45)
        }
        if isWrong {
            return ChemVaultTheme.warning.opacity(0.45)
        }
        if selected {
            return ChemVaultTheme.accent.opacity(0.35)
        }
        return .white.opacity(0.06)
    }
}
