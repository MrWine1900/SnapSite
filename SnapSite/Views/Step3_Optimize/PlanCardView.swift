// MARK: - PlanCardView.swift
// SnapSite · Investment plan cards — Step 3
// Terminology: NEVER "price" or "cost" — only "investment"

import SwiftUI

// MARK: - Standard Plan Card (Essential, Customized, Pro)

struct PlanCardView: View {

    let plan       : InvestmentPlan
    let isSelected : Bool
    let onSelect   : () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 0) {
                cardHeader
                Divider().opacity(0.5)
                featureList
                investmentFooter
            }
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: cardRadius))
            .overlay(cardBorder)
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
            .scaleEffect(isSelected ? 1.01 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    // ─────────────────────────────────────────────
    // MARK: Card Header
    // ─────────────────────────────────────────────

    private var cardHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(plan.tier.rawValue)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(titleColor)

                Text(plan.tagline)
                    .font(.system(size: 12))
                    .foregroundColor(subtitleColor)
            }

            Spacer()

            // Badges
            if let badge = plan.badge {
                Text(badge.label)
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(badge.foreground)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(badge.background)
                    .clipShape(Capsule())
            }

            // Selection indicator
            ZStack {
                Circle()
                    .fill(isSelected ? accentColor : Color.clear)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle().stroke(isSelected ? accentColor : Color(hex: "#D1D5DB"), lineWidth: 2)
                    )
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
    }

    // ─────────────────────────────────────────────
    // MARK: Feature List
    // ─────────────────────────────────────────────

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 9) {
            ForEach(plan.features) { feature in
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: feature.isPremium ? "star.fill" : "checkmark")
                        .font(.system(size: feature.isPremium ? 10 : 11, weight: .bold))
                        .foregroundColor(feature.isPremium ? accentColor : Color(hex: "#22C55E"))
                        .frame(width: 16, height: 16)

                    Text(feature.text)
                        .font(.system(size: 13))
                        .foregroundColor(featureTextColor)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }

    // ─────────────────────────────────────────────
    // MARK: Investment Footer
    // ─────────────────────────────────────────────

    private var investmentFooter: some View {
        VStack(spacing: 2) {
            HStack(alignment: .firstTextBaseline) {
                Text(plan.formattedInvestment)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(titleColor)

                Text("investment")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(subtitleColor)
                    .padding(.leading, 4)

                Spacer()
            }

            if let note = plan.domainNote {
                HStack {
                    Image(systemName: "info.circle")
                        .font(.system(size: 11))
                    Text(note)
                        .font(.system(size: 11))
                }
                .foregroundColor(Color(hex: "#F59E0B"))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 16)
        .padding(.top, 10)
    }

    // ─────────────────────────────────────────────
    // MARK: Styling Helpers
    // ─────────────────────────────────────────────

    private var accentColor: Color {
        plan.isRecommended ? Color(hex: "#4F46E5") : Color(hex: "#6B7280")
    }

    private var cardBackground: some View {
        Group {
            if plan.isRecommended && isSelected {
                LinearGradient(
                    colors: [Color(hex: "#EEF2FF"), Color.white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                Color.white
            }
        }
    }

    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: cardRadius)
            .stroke(
                isSelected
                    ? (plan.isRecommended ? Color(hex: "#4F46E5") : Color(hex: "#6B7280"))
                    : Color(hex: "#E5E7EB"),
                lineWidth: isSelected ? 2 : 1
            )
    }

    private var shadowColor: Color {
        isSelected
            ? (plan.isRecommended ? Color(hex: "#4F46E5").opacity(0.2) : Color.black.opacity(0.1))
            : Color.black.opacity(0.04)
    }
    private var shadowRadius: CGFloat { isSelected ? 16 : 8 }
    private var shadowY      : CGFloat { isSelected ? 8  : 3 }
    private var cardRadius   : CGFloat { 18 }
    private var titleColor   : Color   { Color(hex: "#111827") }
    private var subtitleColor: Color   { Color(hex: "#6B7280") }
    private var featureTextColor: Color { Color(hex: "#374151") }
}

// MARK: - Ultra Premium Card (Plus+)

struct PlusPlusCard: View {

    let plan       : InvestmentPlan
    let isSelected : Bool
    let onSelect   : () -> Void

    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                // Base dark background
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#0A0A0F"), Color(hex: "#12101E"), Color(hex: "#0D0B18")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Gold shimmer overlay
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.clear,
                                Color(hex: "#D4AF37").opacity(0.06),
                                Color.clear
                            ],
                            startPoint: UnitPoint(x: shimmerOffset / 400, y: 0),
                            endPoint: UnitPoint(x: (shimmerOffset + 200) / 400, y: 1)
                        )
                    )
                    .animation(
                        .linear(duration: 3.0).repeatForever(autoreverses: false),
                        value: shimmerOffset
                    )

                // Content
                VStack(alignment: .leading, spacing: 0) {
                    premiumHeader
                    goldDivider
                    premiumFeatures
                    premiumInvestment
                }
            }
            .overlay(premiumBorder)
            .shadow(color: isSelected
                    ? Color(hex: "#D4AF37").opacity(0.3)
                    : Color.black.opacity(0.3),
                    radius: isSelected ? 24 : 12, x: 0, y: isSelected ? 12 : 6)
            .scaleEffect(isSelected ? 1.01 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
        .onAppear { shimmerOffset = 400 }
    }

    // ─────────────────────────────────────────────
    // MARK: Premium Header
    // ─────────────────────────────────────────────

    private var premiumHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                // Limited badge
                if let badge = plan.badge {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 9, weight: .bold))
                        Text(badge.label)
                            .font(.system(size: 10, weight: .black))
                            .kerning(1.2)
                    }
                    .foregroundColor(badge.foreground)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#D4AF37"), Color(hex: "#F5D060")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color(hex: "#D4AF37").opacity(0.6), radius: 8, x: 0, y: 4)
                }

                Text("Plus+")
                    .font(.system(size: 24, weight: .black, design: .serif))
                    .foregroundColor(Color(hex: "#F5D060"))

                Text(plan.tagline)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#D4AF37").opacity(0.7))
            }

            Spacer()

            // Selection indicator
            ZStack {
                Circle()
                    .fill(isSelected ? Color(hex: "#D4AF37") : Color.clear)
                    .frame(width: 24, height: 24)
                    .overlay(
                        Circle().stroke(
                            isSelected ? Color(hex: "#D4AF37") : Color(hex: "#D4AF37").opacity(0.4),
                            lineWidth: 2
                        )
                    )
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(Color(hex: "#0A0A0F"))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 14)
    }

    private var goldDivider: some View {
        LinearGradient(
            colors: [Color.clear, Color(hex: "#D4AF37").opacity(0.4), Color.clear],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(height: 1)
        .padding(.horizontal, 20)
    }

    // ─────────────────────────────────────────────
    // MARK: Premium Features
    // ─────────────────────────────────────────────

    private var premiumFeatures: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(plan.features) { feature in
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: feature.isPremium ? "diamond.fill" : "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(feature.isPremium
                                         ? Color(hex: "#D4AF37")
                                         : Color(hex: "#D4AF37").opacity(0.5))
                        .frame(width: 16)

                    Text(feature.text)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#E5E7EB"))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // ─────────────────────────────────────────────
    // MARK: Premium Investment
    // ─────────────────────────────────────────────

    private var premiumInvestment: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(plan.formattedInvestment)
                .font(.system(size: 32, weight: .black, design: .serif))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color(hex: "#D4AF37"), Color(hex: "#F5D060")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("total investment")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "#D4AF37").opacity(0.6))
                .padding(.leading, 6)

            Spacer()

            // Spots remaining indicator
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color(hex: "#EF4444"))
                        .frame(width: 6, height: 6)
                    Text("3 spots left")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color(hex: "#EF4444"))
                }
                Text("this month")
                    .font(.system(size: 9))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .padding(.top, 8)
    }

    // ─────────────────────────────────────────────
    // MARK: Border
    // ─────────────────────────────────────────────

    private var premiumBorder: some View {
        RoundedRectangle(cornerRadius: 22)
            .stroke(
                LinearGradient(
                    colors: isSelected
                        ? [Color(hex: "#D4AF37"), Color(hex: "#F5D060"), Color(hex: "#B8962E")]
                        : [Color(hex: "#D4AF37").opacity(0.3), Color(hex: "#D4AF37").opacity(0.15)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: isSelected ? 2 : 1
            )
    }
}

// MARK: - Previews

#Preview("Standard Card") {
    VStack(spacing: 16) {
        PlanCardView(plan: .essential,  isSelected: false, onSelect: {})
        PlanCardView(plan: .customized, isSelected: false, onSelect: {})
        PlanCardView(plan: .pro,        isSelected: true,  onSelect: {})
    }
    .padding()
    .background(Color(hex: "#F9FAFB"))
}

#Preview("Premium Card") {
    PlusPlusCard(plan: .plusPlus, isSelected: false, onSelect: {})
        .padding()
        .background(Color(hex: "#F9FAFB"))
}
