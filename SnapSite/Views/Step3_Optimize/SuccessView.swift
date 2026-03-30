// MARK: - SuccessView.swift
// SnapSite · Post-checkout celebration screen

import SwiftUI

struct SuccessView: View {

    @ObservedObject var vm: FunnelViewModel
    @State private var appeared = false
    @State private var confettiScale: CGFloat = 0

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: isPremium
                    ? [Color(hex: "#0A0A0F"), Color(hex: "#12101E")]
                    : [Color(hex: "#4F46E5"), Color(hex: "#7C3AED"), Color(hex: "#1E1B4B")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.03))
                .frame(width: 300)
                .offset(x: 160, y: -200)

            Circle()
                .fill(isPremium
                      ? Color(hex: "#D4AF37").opacity(0.05)
                      : Color.white.opacity(0.03))
                .frame(width: 200)
                .offset(x: -120, y: 200)

            // Content
            VStack(spacing: 0) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(iconBackground)
                        .frame(width: 100, height: 100)
                        .shadow(color: iconShadow, radius: 30, x: 0, y: 10)

                    Image(systemName: isPremium ? "crown.fill" : "checkmark")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(iconForeground)
                }
                .scaleEffect(appeared ? 1 : 0)
                .animation(.spring(response: 0.6, dampingFraction: 0.65).delay(0.2), value: appeared)
                .padding(.bottom, 32)

                // Title
                Text(isPremium ? "Welcome to Plus+" : "You're Live! 🎉")
                    .font(.system(size: 32, weight: .black, design: isPremium ? .serif : .rounded))
                    .foregroundColor(isPremium ? Color(hex: "#F5D060") : .white)
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.4), value: appeared)

                Text(isPremium
                     ? "Your dedicated account manager will contact you within 24 hours."
                     : "Your website is being published. Check your email for next steps.")
                    .font(.system(size: 16))
                    .foregroundColor(isPremium
                                     ? Color(hex: "#D4AF37").opacity(0.8)
                                     : Color.white.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
                    .padding(.horizontal, 40)
                    .padding(.top, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.easeOut(duration: 0.5).delay(0.55), value: appeared)

                Spacer()

                // Summary card
                summaryCard
                    .padding(.horizontal, 24)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 30)
                    .animation(.easeOut(duration: 0.5).delay(0.7), value: appeared)

                Spacer()

                // CTA
                Button {
                    // In production: navigate to dashboard
                } label: {
                    Text(isPremium ? "I'll await your call" : "Go to My Dashboard")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(isPremium ? Color(hex: "#0A0A0F") : Color(hex: "#4F46E5"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(isPremium
                                    ? LinearGradient(
                                        colors: [Color(hex: "#D4AF37"), Color(hex: "#F5D060")],
                                        startPoint: .leading, endPoint: .trailing
                                      )
                                    : LinearGradient(
                                        colors: [Color.white, Color.white],
                                        startPoint: .leading, endPoint: .trailing
                                      ))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
                .opacity(appeared ? 1 : 0)
                .animation(.easeOut(duration: 0.5).delay(0.9), value: appeared)
            }
        }
        .onAppear { appeared = true }
    }

    // ─────────────────────────────────────────────
    // MARK: Summary Card
    // ─────────────────────────────────────────────

    private var summaryCard: some View {
        VStack(spacing: 14) {
            summaryRow(icon: "building.2.fill",
                       label: "Website",
                       value: vm.businessInfo.businessName.isEmpty ? "Your Website" : vm.businessInfo.businessName)

            if let domain = vm.selectedDomain {
                Divider().opacity(0.3)
                summaryRow(icon: "globe",
                           label: "Domain",
                           value: domain.fullDomain)
            }

            Divider().opacity(0.3)
            summaryRow(icon: "bolt.fill",
                       label: "Plan",
                       value: vm.selectedPlan?.tier.rawValue ?? "")

            Divider().opacity(0.3)
            summaryRow(icon: isPremium ? "crown.fill" : "checkmark.seal.fill",
                       label: "Investment",
                       value: vm.formattedTotalInvestment,
                       valueColor: isPremium ? Color(hex: "#D4AF37") : Color(hex: "#22C55E"))
        }
        .padding(20)
        .background(Color.white.opacity(isPremium ? 0.05 : 0.12))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isPremium
                        ? Color(hex: "#D4AF37").opacity(0.3)
                        : Color.white.opacity(0.2),
                        lineWidth: 1)
        )
    }

    private func summaryRow(
        icon: String,
        label: String,
        value: String,
        valueColor: Color? = nil
    ) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(isPremium ? Color(hex: "#D4AF37").opacity(0.7) : Color.white.opacity(0.6))
                .frame(width: 20)
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(isPremium ? Color.white.opacity(0.6) : Color.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(valueColor ?? (isPremium ? Color(hex: "#F5D060") : .white))
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Helpers
    // ─────────────────────────────────────────────

    private var isPremium: Bool { vm.selectedPlan?.tier == .plusPlus }

    private var iconBackground: AnyShapeStyle {
        isPremium
            ? AnyShapeStyle(LinearGradient(
                colors: [Color(hex: "#D4AF37"), Color(hex: "#F5D060")],
                startPoint: .topLeading, endPoint: .bottomTrailing
              ))
            : AnyShapeStyle(Color.white.opacity(0.15))
    }

    private var iconForeground: Color {
        isPremium ? Color(hex: "#0A0A0F") : .white
    }

    private var iconShadow: Color {
        isPremium ? Color(hex: "#D4AF37").opacity(0.5) : Color.white.opacity(0.2)
    }
}

// MARK: - Preview

#Preview {
    let vm = FunnelViewModel()
    vm.selectedPlan = .pro
    vm.businessInfo.businessName = "Bella Cucina"
    vm.selectedDomain = DomainResult(
        name: "bellacucina", tld: ".it",
        availability: .available, annualFee: 8.99, isPopular: false
    )
    vm.checkoutComplete = true
    return SuccessView(vm: vm)
}
