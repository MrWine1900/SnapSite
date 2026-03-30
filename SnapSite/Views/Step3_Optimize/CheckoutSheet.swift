// MARK: - CheckoutSheet.swift
// SnapSite · Checkout + Apple Pay mock

import SwiftUI

struct CheckoutSheet: View {

    @ObservedObject var vm: FunnelViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    investmentSummary
                    orderBreakdown
                    paymentMethods
                    legalFooter
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 40)
            }
            .navigationTitle("Your Investment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") { dismiss() }
                        .foregroundColor(Color(hex: "#4F46E5"))
                }
            }
            .background(Color(hex: "#F9FAFB").ignoresSafeArea())
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }

    // ─────────────────────────────────────────────
    // MARK: Investment Summary Card
    // ─────────────────────────────────────────────

    private var investmentSummary: some View {
        VStack(spacing: 0) {
            // Header gradient
            LinearGradient(
                colors: planGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 90)
            .overlay(
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.selectedPlan?.tier.rawValue ?? "")
                            .font(.system(size: 22, weight: .black))
                            .foregroundColor(planTitleColor)
                        Text("SnapSite Investment")
                            .font(.system(size: 13))
                            .foregroundColor(planTitleColor.opacity(0.7))
                    }
                    Spacer()
                    Text(vm.selectedPlan?.formattedInvestment ?? "")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(planTitleColor)
                }
                .padding(.horizontal, 20)
            )

            // Features list
            if let plan = vm.selectedPlan {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(plan.features.prefix(5)) { feature in
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#22C55E"))
                            Text(feature.text)
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "#374151"))
                        }
                    }
                    if plan.features.count > 5 {
                        Text("+ \(plan.features.count - 5) more features included")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }

    private var planGradient: [Color] {
        if vm.selectedPlan?.tier == .plusPlus {
            return [Color(hex: "#0A0A0F"), Color(hex: "#1a1040")]
        }
        return [Color(hex: "#4F46E5"), Color(hex: "#7C3AED")]
    }

    private var planTitleColor: Color {
        vm.selectedPlan?.tier == .plusPlus ? Color(hex: "#D4AF37") : .white
    }

    // ─────────────────────────────────────────────
    // MARK: Order Breakdown
    // ─────────────────────────────────────────────

    private var orderBreakdown: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Investment Breakdown")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider()

            // Plan line item
            lineItem(
                label: "\(vm.selectedPlan?.tier.rawValue ?? "") Plan",
                value: vm.selectedPlan?.formattedInvestment ?? ""
            )

            // Domain line item (if applicable)
            if let domain = vm.selectedDomain,
               vm.selectedPlan?.domainNote != nil {
                Divider().padding(.leading, 16)
                lineItem(
                    label: "Domain: \(domain.fullDomain) (1 yr)",
                    value: domain.formattedAnnualFee,
                    note: "Charged by registrar"
                )
            }

            Divider()

            // Total
            HStack {
                Text("Total Investment")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                Text(vm.formattedTotalInvestment)
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(
                        vm.selectedPlan?.tier == .plusPlus
                            ? Color(hex: "#D4AF37")
                            : Color(hex: "#4F46E5")
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
    }

    private func lineItem(label: String, value: String, note: String? = nil) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#374151"))
                if let note {
                    Text(note)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
            }
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color(hex: "#111827"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // ─────────────────────────────────────────────
    // MARK: Payment Methods
    // ─────────────────────────────────────────────

    private var paymentMethods: some View {
        VStack(spacing: 14) {
            Text("Payment Method")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(hex: "#111827"))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Apple Pay — Primary CTA
            ApplePayButton(
                amount: vm.formattedTotalInvestment,
                action: vm.processApplePayment,
                isLoading: vm.isProcessingPayment
            )

            // Divider
            HStack {
                Rectangle().fill(Color(hex: "#E5E7EB")).frame(height: 1)
                Text("or pay with card")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .fixedSize()
                Rectangle().fill(Color(hex: "#E5E7EB")).frame(height: 1)
            }

            // Card payment (mock)
            cardPaymentMock
        }
    }

    private var cardPaymentMock: some View {
        VStack(spacing: 14) {
            // Card number field (mock, non-interactive display)
            HStack(spacing: 12) {
                Image(systemName: "creditcard.fill")
                    .foregroundColor(Color(hex: "#9CA3AF"))
                Text("•••• •••• •••• ••••")
                    .font(.system(size: 15, design: .monospaced))
                    .foregroundColor(Color(hex: "#D1D5DB"))
                Spacer()
                HStack(spacing: 6) {
                    ForEach(["visa", "mastercard"], id: \.self) { card in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#F3F4F6"))
                            .frame(width: 36, height: 24)
                            .overlay(
                                Text(card.capitalized)
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundColor(Color(hex: "#6B7280"))
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))

            PrimaryButton(
                title: "Pay \(vm.formattedTotalInvestment)",
                icon: "lock.fill",
                action: vm.processApplePayment,
                isLoading: vm.isProcessingPayment
            )
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Legal Footer
    // ─────────────────────────────────────────────

    private var legalFooter: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                Text("Secured by 256-bit SSL encryption")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }

            Text("By completing your investment you agree to SnapSite's Terms of Service and Privacy Policy. All investments include our 30-day satisfaction guarantee.")
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .padding(.top, 8)
    }
}

// MARK: - Preview

#Preview {
    let vm = FunnelViewModel()
    vm.selectedPlan = .pro
    vm.selectedDomain = DomainResult(
        name: "bellacucina", tld: ".it",
        availability: .available, annualFee: 8.99, isPopular: false
    )
    return CheckoutSheet(vm: vm)
}
