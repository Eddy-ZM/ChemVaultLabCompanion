import SwiftUI

enum CinemaStep: Int, CaseIterable {
    case electronicPreparation = 0
    case lewisAcidActivation = 1
    case orbitalAlignment = 2
    case electronMovement = 3
    case magnesiumAlkoxide = 4
    case acidicWorkup = 5

    var title: String {
        switch self {
        case .electronicPreparation:
            return "Electronic preparation"
        case .lewisAcidActivation:
            return "Lewis acid activation"
        case .orbitalAlignment:
            return "Orbital alignment"
        case .electronMovement:
            return "Concerted electron movement"
        case .magnesiumAlkoxide:
            return "Magnesium alkoxide"
        case .acidicWorkup:
            return "Acidic workup"
        }
    }

    var shortTitle: String {
        switch self {
        case .electronicPreparation:
            return "Prep"
        case .lewisAcidActivation:
            return "Activate"
        case .orbitalAlignment:
            return "Orbitals"
        case .electronMovement:
            return "Attack"
        case .magnesiumAlkoxide:
            return "Alkoxide"
        case .acidicWorkup:
            return "Workup"
        }
    }

    var keyFormula: String {
        switch self {
        case .electronicPreparation:
            return "CH₃δ−–MgBrδ+  +  (CH₃)₂Cδ+=Oδ−"
        case .lewisAcidActivation:
            return "O: → MgBr⁺"
        case .orbitalAlignment:
            return "HOMO(C–Mg) → LUMO(π*C=O)"
        case .electronMovement:
            return "CH₃ → C=O,  π(C=O) → O"
        case .magnesiumAlkoxide:
            return "(CH₃)₃C–O⁻···MgBr⁺"
        case .acidicWorkup:
            return "(CH₃)₃C–O⁻ + H₃O⁺ → (CH₃)₃C–OH"
        }
    }

    var academicText: String {
        switch self {
        case .electronicPreparation:
            return "The C–Mg bond in MeMgBr is strongly polarised toward carbon, giving the methyl group carbanion-like nucleophilic character. The carbonyl C=O bond is polarised toward oxygen, making the carbonyl carbon electrophilic."
        case .lewisAcidActivation:
            return "The carbonyl oxygen coordinates to MgBr⁺. This Lewis acid interaction withdraws electron density from oxygen and increases the electrophilicity of the carbonyl carbon."
        case .orbitalAlignment:
            return "The donor orbital associated with the nucleophilic C–Mg bond aligns with the low-lying π* orbital of the carbonyl. This HOMO–LUMO interaction controls the direction of attack."
        case .electronMovement:
            return "The methyl group attacks the carbonyl carbon while the C=O π electrons move onto oxygen. These electron movements occur together to avoid exceeding the octet at carbon."
        case .magnesiumAlkoxide:
            return "The immediate product is a tetrahedral magnesium alkoxide, represented as (CH₃)₃C–O⁻···MgBr⁺. The neutral alcohol has not formed yet."
        case .acidicWorkup:
            return "During acidic workup, the alkoxide is protonated to form tert-butanol. This is why the final alcohol appears only after quenching the reaction."
        }
    }

    func focusText(for mode: FocusMode) -> String {
        switch mode {
        case .mechanism:
            switch self {
            case .electronicPreparation:
                return "Mechanism view highlights the two reactive partners before any bond forms: the nucleophilic methyl group and the electrophilic carbonyl carbon."
            case .lewisAcidActivation:
                return "Mechanism view shows oxygen donating a lone pair to MgBr⁺, which activates the carbonyl before nucleophilic addition."
            case .orbitalAlignment:
                return "Mechanism view prepares the geometry for attack: the nucleophilic carbon approaches the carbonyl carbon along the π* acceptor direction."
            case .electronMovement:
                return "Mechanism view shows the key curved arrows: CH₃ attacks the carbonyl carbon while the C=O π bond moves to oxygen."
            case .magnesiumAlkoxide:
                return "Mechanism view shows the immediate intermediate: a tetrahedral magnesium alkoxide, not the final alcohol."
            case .acidicWorkup:
                return "Mechanism view separates the organometallic addition step from protonation during workup."
            }

        case .orbitals:
            switch self {
            case .electronicPreparation:
                return "Orbital view shows why the C–Mg bond is nucleophilic: electron density is polarised toward carbon."
            case .lewisAcidActivation:
                return "Orbital view shows that O→Mg coordination lowers the carbonyl π* orbital, making nucleophilic attack easier."
            case .orbitalAlignment:
                return "Orbital view is the main focus here: HOMO donation from the C–Mg bond overlaps with the carbonyl π* LUMO."
            case .electronMovement:
                return "Orbital view connects the curved arrows to bond formation: donation into π* weakens the C=O π bond."
            case .magnesiumAlkoxide:
                return "Orbital view is less central here; the key feature is that the carbonyl π bond has been converted into a C–O single bond with O⁻."
            case .acidicWorkup:
                return "Orbital view is less central during workup; this step is mainly proton transfer from acid to alkoxide oxygen."
            }

        case .charges:
            switch self {
            case .electronicPreparation:
                return "Charge view highlights Cδ−–Mgδ+ and Cδ+=Oδ−. These polarised bonds determine the nucleophile and electrophile."
            case .lewisAcidActivation:
                return "Charge view highlights MgBr⁺ as a Lewis acid and oxygen as the donor site."
            case .orbitalAlignment:
                return "Charge view helps explain why the electron-rich methyl carbon approaches the electron-poor carbonyl carbon."
            case .electronMovement:
                return "Charge view follows charge redistribution: electron density leaves the methyl carbon and the C=O π electrons shift toward oxygen."
            case .magnesiumAlkoxide:
                return "Charge view highlights O⁻···MgBr⁺. The intermediate is ionic/coordination-stabilised, not a neutral alcohol."
            case .acidicWorkup:
                return "Charge view shows the disappearance of O⁻ as protonation gives the neutral O–H bond."
            }

        case .energy:
            switch self {
            case .electronicPreparation:
                return "Energy view starts at the reactants. The reaction has not crossed the bond-forming transition state yet."
            case .lewisAcidActivation:
                return "Energy view shows activation: coordination helps lower the barrier for carbonyl addition."
            case .orbitalAlignment:
                return "Energy view places orbital alignment before the major bond-forming transition state."
            case .electronMovement:
                return "Energy view places this step near the transition state where C–C bond formation and C=O π-bond breaking occur together."
            case .magnesiumAlkoxide:
                return "Energy view shows the magnesium alkoxide as the main intermediate after nucleophilic addition."
            case .acidicWorkup:
                return "Energy view treats workup as a later proton-transfer process leading to the isolated alcohol."
            }
        }
    }

    func focusTakeaways(for mode: FocusMode) -> [String] {
        switch mode {
        case .mechanism:
            switch self {
            case .electronicPreparation:
                return ["Identify the nucleophile before drawing arrows.", "Do not treat MeMgBr as free CH₃⁻.", "The carbonyl carbon is the electrophilic centre."]
            case .lewisAcidActivation:
                return ["Oxygen donates to MgBr⁺.", "Coordination activates the carbonyl.", "This organises the reacting partners."]
            case .orbitalAlignment:
                return ["Attack follows orbital alignment.", "The donor approaches the π* acceptor.", "Geometry matters for bond formation."]
            case .electronMovement:
                return ["Arrow from methyl carbon to carbonyl carbon.", "Arrow from C=O π bond to oxygen.", "C–C bond forms as C=O π bond breaks."]
            case .magnesiumAlkoxide:
                return ["Intermediate is not alcohol.", "Oxygen is negatively charged.", "MgBr⁺ remains associated with oxygen."]
            case .acidicWorkup:
                return ["Acid provides H⁺.", "O⁻ becomes OH.", "Alcohol appears only after workup."]
            }
        case .orbitals:
            return ["HOMO donation explains nucleophilicity.", "Carbonyl π* is the acceptor orbital.", "Lewis acid coordination improves orbital matching."]
        case .charges:
            return ["Follow δ− and δ+ labels.", "Electrons move from rich to poor centres.", "O⁻ is stabilised by MgBr⁺ before workup."]
        case .energy:
            return ["Reactants precede the transition state.", "C–C formation is the main barrier.", "Alkoxide is an intermediate; product follows workup."]
        }
    }
}

enum FocusMode: String, CaseIterable {
    case mechanism = "Mechanism"
    case orbitals = "Orbitals"
    case charges = "Charges"
    case energy = "Energy"

    var icon: String {
        switch self {
        case .mechanism:
            return "arrow.triangle.branch"
        case .orbitals:
            return "waveform.path.ecg"
        case .charges:
            return "plusminus"
        case .energy:
            return "chart.xyaxis.line"
        }
    }

    var subtitle: String {
        switch self {
        case .mechanism:
            return "Curved arrows"
        case .orbitals:
            return "HOMO → LUMO"
        case .charges:
            return "δ+/δ− map"
        case .energy:
            return "Reaction path"
        }
    }
}
