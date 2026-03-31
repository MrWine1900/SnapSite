// MARK: - WebsiteProject.swift
// SnapSite · Core Domain Model

import SwiftUI
import UIKit

// MARK: - Business Info

struct BusinessInfo {
    var businessName : String = ""
    var businessType : BusinessType = .other
    var tagline      : String = ""
    var primaryColor : Color = Color(hex: "#4F46E5")
    var photos       : [SnapPhoto] = []
}

enum BusinessType: String, CaseIterable, Identifiable {
    case restaurant   = "Restaurant & Food"
    case ecommerce    = "E-Commerce"
    case services     = "Professional Services"
    case portfolio    = "Portfolio / Creative"
    case fitness      = "Fitness & Wellness"
    case realEstate   = "Real Estate"
    case other        = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .restaurant:  return "fork.knife"
        case .ecommerce:   return "bag.fill"
        case .services:    return "briefcase.fill"
        case .portfolio:   return "paintbrush.fill"
        case .fitness:     return "figure.run"
        case .realEstate:  return "house.fill"
        case .other:       return "sparkles"
        }
    }
}

// MARK: - SnapPhoto  (wraps UIImage with an ID)

struct SnapPhoto: Identifiable {
    let id    = UUID()
    let image : UIImage
}

// MARK: - Generated Website Mock

struct GeneratedWebsite {
    let heroTitle     : String
    let heroSubtitle  : String
    let colorScheme   : WebColorScheme
    let sections      : [WebSection]
    let thumbnailMock : WebThumbnailStyle
}

struct WebColorScheme {
    let primary   : Color
    let secondary : Color
    let background: Color
    let text      : Color
}

struct WebSection {
    let title   : String
    let icon    : String
}

enum WebThumbnailStyle {
    case modern, minimal, bold, elegant
}

extension GeneratedWebsite {
    static func mock(for info: BusinessInfo) -> GeneratedWebsite {
        GeneratedWebsite(
            heroTitle: info.businessName.isEmpty ? "Your Brand" : info.businessName,
            heroSubtitle: info.tagline.isEmpty
                ? "Crafted with care · Powered by AI"
                : info.tagline,
            colorScheme: WebColorScheme(
                primary:    info.primaryColor,
                secondary:  Color(hex: "#818CF8"),
                background: Color(hex: "#F9FAFB"),
                text:       Color(hex: "#111827")
            ),
            sections: [
                WebSection(title: "Home",     icon: "house.fill"),
                WebSection(title: "About",    icon: "person.fill"),
                WebSection(title: "Services", icon: "star.fill"),
                WebSection(title: "Gallery",  icon: "photo.fill"),
                WebSection(title: "Contact",  icon: "envelope.fill"),
            ],
            thumbnailMock: .modern
        )
    }
}

// MARK: - Funnel Step

enum FunnelStep: Int, CaseIterable {
    case generator = 0
    case domain    = 1
    case optimize  = 2

    var title: String {
        switch self {
        case .generator: return "Create"
        case .domain:    return "Domain"
        case .optimize:  return "Publish"
        }
    }

    var icon: String {
        switch self {
        case .generator: return "wand.and.stars"
        case .domain:    return "globe"
        case .optimize:  return "bolt.fill"
        }
    }
}
