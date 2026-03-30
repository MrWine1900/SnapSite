// MARK: - FunnelViewModel.swift
// SnapSite · Central MVVM orchestrator for the 3-step sales funnel

import SwiftUI
import Combine

@MainActor
final class FunnelViewModel: ObservableObject {

    // ─────────────────────────────────────────────
    // MARK: Funnel Navigation
    // ─────────────────────────────────────────────

    @Published var currentStep: FunnelStep = .generator
    @Published var isTransitioning: Bool = false

    // ─────────────────────────────────────────────
    // MARK: Step 1 — Website Generator
    // ─────────────────────────────────────────────

    @Published var businessInfo = BusinessInfo()
    @Published var isGenerating: Bool = false
    @Published var generationProgress: Double = 0.0
    @Published var generationPhase: GenerationPhase = .idle
    @Published var generatedWebsite: GeneratedWebsite? = nil
    @Published var showWebsitePreview: Bool = false

    // ─────────────────────────────────────────────
    // MARK: Step 2 — Domain Search
    // ─────────────────────────────────────────────

    @Published var domainQuery: String = ""
    @Published var domainResults: [DomainResult] = []
    @Published var isSearchingDomain: Bool = false
    @Published var selectedDomain: DomainResult? = nil

    // ─────────────────────────────────────────────
    // MARK: Step 3 — Optimize & Publish
    // ─────────────────────────────────────────────

    @Published var plans: [InvestmentPlan] = InvestmentPlan.catalog
    @Published var selectedPlan: InvestmentPlan? = nil
    @Published var showCheckoutSheet: Bool = false
    @Published var checkoutComplete: Bool = false
    @Published var isProcessingPayment: Bool = false

    // ─────────────────────────────────────────────
    // MARK: Step 1 — Generation Logic
    // ─────────────────────────────────────────────

    enum GenerationPhase: String {
        case idle        = ""
        case scanning    = "Scanning your photos…"
        case designing   = "Crafting your design…"
        case optimising  = "Optimising for mobile…"
        case finalising  = "Almost ready…"
        case done        = "Your site is ready!"
    }

    func generateWebsite() {
        guard canGenerate else { return }
        isGenerating = true
        showWebsitePreview = false
        generationProgress = 0.0

        let timeline: [(delay: Double, progress: Double, phase: GenerationPhase)] = [
            (0.0,  0.05, .scanning),
            (0.8,  0.30, .scanning),
            (1.6,  0.55, .designing),
            (2.4,  0.72, .optimising),
            (3.2,  0.88, .finalising),
            (4.0,  1.00, .finalising),
        ]

        for step in timeline {
            DispatchQueue.main.asyncAfter(deadline: .now() + step.delay) {
                withAnimation(.easeInOut(duration: 0.6)) {
                    self.generationProgress = step.progress
                    self.generationPhase    = step.phase
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4.6) {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
                self.generationPhase   = .done
                self.generatedWebsite  = GeneratedWebsite.mock(for: self.businessInfo)
                self.isGenerating      = false
                self.showWebsitePreview = true
            }
        }
    }

    var canGenerate: Bool {
        !businessInfo.businessName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // ─────────────────────────────────────────────
    // MARK: Funnel Navigation
    // ─────────────────────────────────────────────

    func advance(to step: FunnelStep) {
        guard !isTransitioning else { return }
        isTransitioning = true
        withAnimation(.easeInOut(duration: 0.45)) {
            currentStep = step
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isTransitioning = false
        }
    }

    func proceedToDomain() { advance(to: .domain) }
    func proceedToOptimize() { advance(to: .optimize) }

    // ─────────────────────────────────────────────
    // MARK: Step 2 — Domain Search Logic
    // ─────────────────────────────────────────────

    func searchDomain() {
        let q = domainQuery.trimmingCharacters(in: .whitespaces)
        guard q.count >= 2 else { return }
        isSearchingDomain = true
        domainResults = []
        selectedDomain = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            withAnimation(.easeOut(duration: 0.4)) {
                self.domainResults    = DomainSearchEngine.search(query: q)
                self.isSearchingDomain = false
            }
        }
    }

    func selectDomain(_ domain: DomainResult) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedDomain = (selectedDomain?.id == domain.id) ? nil : domain
        }
    }

    var canProceedToOptimize: Bool {
        selectedDomain != nil || domainResults.isEmpty == false
    }

    // ─────────────────────────────────────────────
    // MARK: Step 3 — Plan Selection & Checkout
    // ─────────────────────────────────────────────

    func selectPlan(_ plan: InvestmentPlan) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.72)) {
            selectedPlan = plan
        }
    }

    func openCheckout() {
        guard selectedPlan != nil else { return }
        showCheckoutSheet = true
    }

    func processApplePayment() {
        isProcessingPayment = true
        // Simulated payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                self.isProcessingPayment = false
                self.checkoutComplete    = true
                self.showCheckoutSheet   = false
            }
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Investment Summary
    // ─────────────────────────────────────────────

    var totalInvestment: Double {
        guard let plan = selectedPlan else { return 0 }
        var total = plan.investment
        // If plan doesn't include domain and user selected one, add the domain fee
        if !plan.tier.includesDomain, let domain = selectedDomain {
            total += domain.annualFee
        }
        return total
    }

    var formattedTotalInvestment: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "EUR"
        fmt.currencySymbol = "€"
        fmt.maximumFractionDigits = 0
        return fmt.string(from: NSNumber(value: totalInvestment)) ?? "€\(Int(totalInvestment))"
    }
}

// MARK: - PlanTier helper

private extension PlanTier {
    var includesDomain: Bool {
        switch self {
        case .essential: return false
        case .customized, .pro, .plusPlus: return true
        }
    }
}
