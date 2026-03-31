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

        Task {
            await runGenerationSequence()
        }
    }

    private func runGenerationSequence() async {
        let steps: [(nanoseconds: UInt64, progress: Double, phase: GenerationPhase)] = [
            (0,                 0.05, .scanning),
            (800_000_000,       0.30, .scanning),
            (800_000_000,       0.55, .designing),
            (800_000_000,       0.72, .optimising),
            (800_000_000,       0.88, .finalising),
            (800_000_000,       1.00, .finalising),
        ]

        for step in steps {
            if step.nanoseconds > 0 {
                try? await Task.sleep(nanoseconds: step.nanoseconds)
            }
            withAnimation(.easeInOut(duration: 0.6)) {
                self.generationProgress = step.progress
                self.generationPhase    = step.phase
            }
        }

        try? await Task.sleep(nanoseconds: 600_000_000)
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
            self.generationPhase    = .done
            self.generatedWebsite   = GeneratedWebsite.mock(for: self.businessInfo)
            self.isGenerating       = false
            self.showWebsitePreview = true
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
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            self.isTransitioning = false
        }
    }

    func proceedToDomain()   { advance(to: .domain) }
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

        Task {
            try? await Task.sleep(nanoseconds: 1_400_000_000)
            withAnimation(.easeOut(duration: 0.4)) {
                self.domainResults     = DomainSearchEngine.search(query: q)
                self.isSearchingDomain = false
            }
        }
    }

    func selectDomain(_ domain: DomainResult) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedDomain = (selectedDomain?.id == domain.id) ? nil : domain
        }
    }

    var canProceedToOptimize: Bool { !domainResults.isEmpty }

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
        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
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
        if plan.tier == .essential, let domain = selectedDomain {
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
