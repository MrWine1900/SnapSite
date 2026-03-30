// MARK: - OptimizePublishView.swift
// SnapSite · Step 3 — Optimize & Publish (The Checkout Funnel)
// IMPORTANT: NEVER use "cost" or "price" — ALWAYS "investment"

import SwiftUI

struct OptimizePublishView: View {

    @ObservedObject var vm: FunnelViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                    domainSummaryBanner
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    plansList
                        .padding(.top, 24)
                    guaranteeStrip
                        .padding(.horizontal, 20)
                        .padding(.top, 28)
                    Spacer(minLength: 100) // space for sticky CTA
                }
            }

            // Sticky bottom CTA
            if vm.selectedPlan != nil {
                stickyCheckoutBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color(hex: "#F9FAFB").ignoresSafeArea())
        .sheet(isPresented: $vm.showCheckoutSheet) {
            CheckoutSheet(vm: vm)
        }
        .fullScreenCover(isPresented: $vm.checkoutComplete) {
            SuccessView(vm: vm)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.selectedPlan?.id)
    }

    // ─────────────────────────────────────────────
    // MARK: Header
    // ─────────────────────────────────────────────

    private var header: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [Color(hex: "#111827"), Color(hex: "#1F2937")],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 180)

            // Decorative bolt
            Image(systemName: "bolt.fill")
                .font(.system(size: 100, weight: .black))
                .foregroundColor(Color.white.opacity(0.03))
                .offset(x: 130, y: 10)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#FCD34D"))
                    Text("STEP 3 OF 3")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#FCD34D"))
                        .kerning(1.5)
                }

                Text("Optimize &\nPublish")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)

                Text("Choose your investment level and go live today.")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Domain Summary
    // ─────────────────────────────────────────────

    private var domainSummaryBanner: some View {
        Group {
            if let domain = vm.selectedDomain {
                HStack(spacing: 12) {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#22C55E"))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(domain.fullDomain)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Domain reserved · \(domain.formattedAnnualFee)/year (billed separately)")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }

                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#22C55E"))
                }
                .padding(14)
                .background(Color(hex: "#F0FDF4"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#22C55E").opacity(0.25), lineWidth: 1)
                )
            }
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Plans List
    // ─────────────────────────────────────────────

    private var plansList: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Section title
            HStack {
                Text("Select Your Investment")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                Image(systemName: "info.circle")
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
            .padding(.horizontal, 20)

            // Essential — standard card
            PlanCardView(
                plan: .essential,
                isSelected: vm.selectedPlan?.tier == .essential,
                onSelect: { vm.selectPlan(.essential) }
            )
            .padding(.horizontal, 20)

            // Customized — standard card
            PlanCardView(
                plan: .customized,
                isSelected: vm.selectedPlan?.tier == .customized,
                onSelect: { vm.selectPlan(.customized) }
            )
            .padding(.horizontal, 20)

            // PRO — recommended, visually elevated
            recommendedProCard
                .padding(.horizontal, 12) // slightly wider breakout

            // PLUS+ — ultra premium
            VStack(alignment: .leading, spacing: 10) {
                PlusPlusCard(
                    plan: .plusPlus,
                    isSelected: vm.selectedPlan?.tier == .plusPlus,
                    onSelect: { vm.selectPlan(.plusPlus) }
                )
            }
            .padding(.horizontal, 20)
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Pro Card (Recommended — visually elevated)
    // ─────────────────────────────────────────────

    private var recommendedProCard: some View {
        VStack(spacing: 0) {
            // "Recommended" label above the card
            HStack {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 11))
                    .foregroundColor(.white)
                Text("RECOMMENDED FOR YOU")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.white)
                    .kerning(0.5)
            }
            .padding(.horizontal, 16)
            .frame(height: 30)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED")],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 18, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0, topTrailingRadius: 18
                )
            )

            // Card body
            PlanCardView(
                plan: .pro,
                isSelected: vm.selectedPlan?.tier == .pro,
                onSelect: { vm.selectPlan(.pro) }
            )
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0, bottomLeadingRadius: 18,
                    bottomTrailingRadius: 18, topTrailingRadius: 0
                )
            )
        }
        .shadow(color: Color(hex: "#4F46E5").opacity(0.25), radius: 20, x: 0, y: 10)
    }

    // ─────────────────────────────────────────────
    // MARK: Guarantee Strip
    // ─────────────────────────────────────────────

    private var guaranteeStrip: some View {
        HStack(spacing: 0) {
            GuaranteeItem(icon: "shield.checkered", text: "30-day\nguarantee")
            Divider().frame(height: 40)
            GuaranteeItem(icon: "lock.fill", text: "Secure\npayment")
            Divider().frame(height: 40)
            GuaranteeItem(icon: "arrow.uturn.backward", text: "Full\nrefund")
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color(hex: "#E5E7EB"), lineWidth: 1))
    }

    // ─────────────────────────────────────────────
    // MARK: Sticky Checkout Bar
    // ─────────────────────────────────────────────

    private var stickyCheckoutBar: some View {
        VStack(spacing: 10) {
            // Investment summary
            if let plan = vm.selectedPlan {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(plan.tier.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("Your investment today")
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }

                    Spacer()

                    Text(vm.formattedTotalInvestment)
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(
                            plan.tier == .plusPlus ? Color(hex: "#D4AF37") : Color(hex: "#4F46E5")
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }

            // CTA Button
            Group {
                if vm.selectedPlan?.tier == .plusPlus {
                    GoldCTAButton(
                        title: "Request Exclusive Access",
                        action: vm.openCheckout
                    )
                } else {
                    PrimaryButton(
                        title: "Complete My Investment →",
                        icon: nil,
                        action: vm.openCheckout
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 32)
        }
        .background(
            Color.white
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20, bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0, topTrailingRadius: 20
                    )
                )
                .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: -6)
        )
    }
}

// MARK: - Guarantee Item

private struct GuaranteeItem: View {
    let icon: String
    let text: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "#4F46E5"))
            Text(text)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(Color(hex: "#6B7280"))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    let vm = FunnelViewModel()
    vm.businessInfo.businessName = "Bella Cucina"
    vm.selectedDomain = DomainResult(
        name: "bellacucina", tld: ".it",
        availability: .available, annualFee: 8.99, isPopular: false
    )
    return OptimizePublishView(vm: vm)
}
