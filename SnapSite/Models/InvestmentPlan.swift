// MARK: - InvestmentPlan.swift
// SnapSite · Sales Funnel Models
// Terminology rule: NEVER use "price" or "cost" — always "investment"

import SwiftUI

// MARK: - Plan Tier

enum PlanTier: String, CaseIterable, Identifiable {
    case essential  = "Essential"
    case customized = "Customized"
    case pro        = "Pro"
    case plusPlus   = "Plus+"

    var id: String { rawValue }
}

// MARK: - Investment Plan

struct InvestmentPlan: Identifiable {
    let id           = UUID()
    let tier         : PlanTier
    let investment   : Double          // "investment" — never "price"
    let tagline      : String
    let features     : [PlanFeature]
    let domainNote   : String?         // e.g. "Domain sold separately"
    let badge        : PlanBadge?
    let isRecommended: Bool
    let isLimited    : Bool
    let accentStyle  : PlanAccentStyle
}

// MARK: - Plan Feature

struct PlanFeature: Identifiable {
    let id      = UUID()
    let text    : String
    let isPremium: Bool
}

// MARK: - Plan Badge

struct PlanBadge {
    let label      : String
    let background : Color
    let foreground : Color
}

// MARK: - Accent Style (drives the card appearance)

enum PlanAccentStyle {
    case standard   // grey/white
    case highlighted // brand blue/teal
    case recommended // vivid accent, scaled up
    case ultraPremium // near-black + gold
}

// MARK: - Static Data

extension InvestmentPlan {

    static let catalog: [InvestmentPlan] = [essential, customized, pro, plusPlus]

    // ─────────────────────────────────────────────
    // ESSENTIAL · 29 €
    // ─────────────────────────────────────────────
    static let essential = InvestmentPlan(
        tier: .essential,
        investment: 29,
        tagline: "Get online fast",
        features: [
            PlanFeature(text: "AI-generated website",   isPremium: false),
            PlanFeature(text: "Up to 5 pages",          isPremium: false),
            PlanFeature(text: "Mobile responsive",      isPremium: false),
            PlanFeature(text: "Free SSL certificate",   isPremium: false),
            PlanFeature(text: "1-month hosting",        isPremium: false),
        ],
        domainNote: "Domain cost is separate",
        badge: nil,
        isRecommended: false,
        isLimited: false,
        accentStyle: .standard
    )

    // ─────────────────────────────────────────────
    // CUSTOMIZED · 89 €
    // ─────────────────────────────────────────────
    static let customized = InvestmentPlan(
        tier: .customized,
        investment: 89,
        tagline: "Everything to launch",
        features: [
            PlanFeature(text: "All Essential features", isPremium: false),
            PlanFeature(text: "Domain included (1 yr)", isPremium: false),
            PlanFeature(text: "Up to 10 pages",         isPremium: false),
            PlanFeature(text: "Custom colour palette",  isPremium: false),
            PlanFeature(text: "Contact form",           isPremium: false),
            PlanFeature(text: "6-month hosting",        isPremium: false),
        ],
        domainNote: nil,
        badge: nil,
        isRecommended: false,
        isLimited: false,
        accentStyle: .highlighted
    )

    // ─────────────────────────────────────────────
    // PRO · 199 €  ← RECOMMENDED
    // ─────────────────────────────────────────────
    static let pro = InvestmentPlan(
        tier: .pro,
        investment: 199,
        tagline: "The smart choice",
        features: [
            PlanFeature(text: "All Customized features",       isPremium: false),
            PlanFeature(text: "Full SEO optimization",         isPremium: true),
            PlanFeature(text: "Google Analytics integration",  isPremium: true),
            PlanFeature(text: "E-commerce (up to 50 products)",isPremium: true),
            PlanFeature(text: "Blog & news section",           isPremium: true),
            PlanFeature(text: "Priority support",              isPremium: true),
            PlanFeature(text: "12-month hosting",              isPremium: true),
        ],
        domainNote: nil,
        badge: PlanBadge(
            label: "MOST POPULAR",
            background: Color(hex: "#4F46E5"),
            foreground: .white
        ),
        isRecommended: true,
        isLimited: false,
        accentStyle: .recommended
    )

    // ─────────────────────────────────────────────
    // PLUS+ · 2 999 €  ← LIMITED
    // ─────────────────────────────────────────────
    static let plusPlus = InvestmentPlan(
        tier: .plusPlus,
        investment: 2_999,
        tagline: "White-glove concierge",
        features: [
            PlanFeature(text: "All Pro features",              isPremium: false),
            PlanFeature(text: "Dedicated account manager",     isPremium: true),
            PlanFeature(text: "Bespoke design & branding",     isPremium: true),
            PlanFeature(text: "Unlimited products",            isPremium: true),
            PlanFeature(text: "Advanced analytics dashboard",  isPremium: true),
            PlanFeature(text: "Marketing automation suite",    isPremium: true),
            PlanFeature(text: "Weekly performance reports",    isPremium: true),
            PlanFeature(text: "24/7 priority support",         isPremium: true),
            PlanFeature(text: "Lifetime hosting included",     isPremium: true),
        ],
        domainNote: nil,
        badge: PlanBadge(
            label: "LIMITED",
            background: Color(hex: "#D4AF37"),
            foreground: Color(hex: "#0A0A0F")
        ),
        isRecommended: false,
        isLimited: true,
        accentStyle: .ultraPremium
    )
}

// MARK: - Formatting Helpers

extension InvestmentPlan {
    var formattedInvestment: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "EUR"
        fmt.currencySymbol = "€"
        fmt.maximumFractionDigits = 0
        return fmt.string(from: NSNumber(value: investment)) ?? "€\(Int(investment))"
    }
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8)*17, (int >> 4 & 0xF)*17, (int & 0xF)*17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red:   Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
