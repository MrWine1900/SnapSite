// MARK: - DomainResult.swift
// SnapSite · Domain Search Model

import SwiftUI

// MARK: - Domain Availability

enum DomainAvailability: String {
    case available = "Available"
    case taken     = "Taken"
    case premium   = "Premium"

    var color: Color {
        switch self {
        case .available: return Color(hex: "#22C55E")
        case .taken:     return Color(hex: "#EF4444")
        case .premium:   return Color(hex: "#F59E0B")
        }
    }

    var icon: String {
        switch self {
        case .available: return "checkmark.circle.fill"
        case .taken:     return "xmark.circle.fill"
        case .premium:   return "star.circle.fill"
        }
    }
}

// MARK: - Domain Result

struct DomainResult: Identifiable, Hashable {
    let id          = UUID()
    let name        : String
    let tld         : String
    let availability: DomainAvailability
    let annualFee   : Double   // domain registration is external — shown as annual fee
    let isPopular   : Bool

    var fullDomain: String { "\(name)\(tld)" }

    var formattedAnnualFee: String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .currency
        fmt.currencyCode = "EUR"
        fmt.currencySymbol = "€"
        return fmt.string(from: NSNumber(value: annualFee)) ?? "€\(annualFee)"
    }

    // Hashable conformance (UUID already unique)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: DomainResult, rhs: DomainResult) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mock Domain Search Engine

struct DomainSearchEngine {

    static func search(query: String) -> [DomainResult] {
        let base = query
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .filter { $0.isLetter || $0.isNumber || $0 == "-" }
        guard !base.isEmpty else { return [] }

        return [
            DomainResult(name: base,           tld: ".com",    availability: .taken,     annualFee:  12.99, isPopular: true),
            DomainResult(name: base,           tld: ".it",     availability: .available, annualFee:   8.99, isPopular: false),
            DomainResult(name: base,           tld: ".io",     availability: .available, annualFee:  39.99, isPopular: true),
            DomainResult(name: base,           tld: ".co",     availability: .available, annualFee:  19.99, isPopular: false),
            DomainResult(name: base,           tld: ".eu",     availability: .available, annualFee:   6.99, isPopular: false),
            DomainResult(name: "\(base)pro",   tld: ".com",    availability: .available, annualFee:  12.99, isPopular: false),
            DomainResult(name: "\(base)app",   tld: ".com",    availability: .available, annualFee:  14.99, isPopular: false),
            DomainResult(name: "\(base)hq",    tld: ".com",    availability: .available, annualFee:  12.99, isPopular: false),
            DomainResult(name: "\(base)studio",tld: ".com",    availability: .premium,   annualFee: 299.00, isPopular: false),
            DomainResult(name: "get\(base)",   tld: ".com",    availability: .available, annualFee:  12.99, isPopular: false),
        ]
    }
}
