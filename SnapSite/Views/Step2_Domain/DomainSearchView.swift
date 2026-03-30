// MARK: - DomainSearchView.swift
// SnapSite · Step 2 — Domain Search

import SwiftUI

struct DomainSearchView: View {

    @ObservedObject var vm: FunnelViewModel
    @FocusState private var searchFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Fixed header
            header

            // Scrollable results
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    searchBar
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                    if vm.isSearchingDomain {
                        searchingState
                    } else if !vm.domainResults.isEmpty {
                        resultsSection
                            .padding(.horizontal, 20)
                    } else if vm.domainQuery.isEmpty {
                        emptyPrompt
                    }

                    if !vm.domainResults.isEmpty {
                        ctaSection
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F9FAFB").ignoresSafeArea())
        .onTapGesture { searchFocused = false }
    }

    // ─────────────────────────────────────────────
    // MARK: Header
    // ─────────────────────────────────────────────

    private var header: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [Color(hex: "#0F172A"), Color(hex: "#1E293B")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 160)

            // Decorative globe
            Image(systemName: "globe")
                .font(.system(size: 90, weight: .ultraLight))
                .foregroundColor(Color.white.opacity(0.04))
                .offset(x: 120, y: 0)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#38BDF8"))
                    Text("STEP 2 OF 3")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#38BDF8"))
                        .kerning(1.5)
                }

                Text("Find Your\nDomain")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .foregroundColor(.white)

                Text("Search & reserve the perfect address for your site.")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Search Bar
    // ─────────────────────────────────────────────

    private var searchBar: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(
                        searchFocused ? Color(hex: "#4F46E5") : Color(hex: "#9CA3AF")
                    )

                TextField("yourname or yourbusiness", text: $vm.domainQuery)
                    .font(.system(size: 16))
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($searchFocused)
                    .onSubmit { vm.searchDomain() }

                if !vm.domainQuery.isEmpty {
                    Button {
                        vm.domainQuery = ""
                        vm.domainResults = []
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.black.opacity(0.07), radius: 10, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        searchFocused ? Color(hex: "#4F46E5") : Color.clear,
                        lineWidth: 1.5
                    )
            )

            Button(action: vm.searchDomain) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 52, height: 52)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .shadow(color: Color(hex: "#4F46E5").opacity(0.3), radius: 8, x: 0, y: 4)
            }
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Searching State
    // ─────────────────────────────────────────────

    private var searchingState: some View {
        VStack(spacing: 20) {
            // Simulated "connecting to registrar" animation
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#4F46E5")))
                    .scaleEffect(1.3)

                Text("Connecting to domain registrars…")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            .padding(.top, 60)

            // Animated registry list (mock)
            VStack(spacing: 8) {
                ForEach(["ICANN", "Verisign", ".IT Registry", "CIRA", "Nominet"], id: \.self) { reg in
                    RegistrarRow(name: reg)
                }
            }
            .padding(.horizontal, 20)
        }
        .transition(.opacity)
    }

    // ─────────────────────────────────────────────
    // MARK: Results
    // ─────────────────────────────────────────────

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Available Domains")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Spacer()
                Text("\(vm.domainResults.filter { $0.availability != .taken }.count) available")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#6B7280"))
            }

            VStack(spacing: 10) {
                ForEach(vm.domainResults) { domain in
                    DomainRow(
                        domain: domain,
                        isSelected: vm.selectedDomain?.id == domain.id,
                        onSelect: { vm.selectDomain(domain) }
                    )
                    .transition(.move(edge: .leading).combined(with: .opacity))
                }
            }

            // Disclaimer
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .padding(.top, 1)
                Text("Domain registration fees are charged separately by the domain registrar and are not included in your SnapSite investment.")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#9CA3AF"))
                    .lineSpacing(3)
            }
            .padding(12)
            .background(Color(hex: "#F3F4F6"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Empty Prompt
    // ─────────────────────────────────────────────

    private var emptyPrompt: some View {
        VStack(spacing: 16) {
            Image(systemName: "globe.desk")
                .font(.system(size: 52, weight: .ultraLight))
                .foregroundColor(Color(hex: "#D1D5DB"))

            Text("Search for your domain")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(hex: "#374151"))

            Text("Type your business name above to\ncheck domain availability")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.top, 60)
    }

    // ─────────────────────────────────────────────
    // MARK: CTA
    // ─────────────────────────────────────────────

    private var ctaSection: some View {
        VStack(spacing: 12) {
            if let selected = vm.selectedDomain {
                // Selected domain summary
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "#22C55E"))
                    Text(selected.fullDomain)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                    Spacer()
                    Text("\(selected.formattedAnnualFee)/yr")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                .padding(14)
                .background(Color(hex: "#F0FDF4"))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "#22C55E").opacity(0.3), lineWidth: 1)
                )
            }

            PrimaryButton(
                title: vm.selectedDomain != nil ? "Continue with \(vm.selectedDomain!.fullDomain)" : "Skip & Continue",
                icon: "arrow.right",
                action: vm.proceedToOptimize
            )

            Text("Next: choose your optimisation investment")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#9CA3AF"))
        }
        .padding(.top, 8)
    }
}

// MARK: - Domain Row

private struct DomainRow: View {
    let domain    : DomainResult
    let isSelected: Bool
    let onSelect  : () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 14) {
                // TLD badge
                Text(domain.tld)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(tldColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(tldColor.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                // Domain name
                VStack(alignment: .leading, spacing: 2) {
                    Text(domain.fullDomain)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(domain.availability == .taken
                                         ? Color(hex: "#9CA3AF")
                                         : Color(hex: "#111827"))
                        .strikethrough(domain.availability == .taken, color: Color(hex: "#EF4444"))

                    if domain.isPopular {
                        Text("Popular choice")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(hex: "#F59E0B"))
                    }
                }

                Spacer()

                // Right side
                HStack(spacing: 8) {
                    if domain.availability != .taken {
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(domain.formattedAnnualFee)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(hex: "#111827"))
                            Text("/year")
                                .font(.system(size: 10))
                                .foregroundColor(Color(hex: "#9CA3AF"))
                        }
                    }

                    // Availability indicator
                    Image(systemName: domain.availability.icon)
                        .font(.system(size: 18))
                        .foregroundColor(domain.availability.color)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(rowBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(domain.availability == .taken)
    }

    private var tldColor: Color {
        switch domain.tld {
        case ".com": return Color(hex: "#2563EB")
        case ".io":  return Color(hex: "#7C3AED")
        case ".it":  return Color(hex: "#059669")
        case ".co":  return Color(hex: "#D97706")
        default:     return Color(hex: "#6B7280")
        }
    }

    private var rowBackground: Color {
        if domain.availability == .taken { return Color(hex: "#F9FAFB") }
        if isSelected { return Color(hex: "#EEF2FF") }
        return .white
    }

    private var borderColor: Color {
        if isSelected { return Color(hex: "#4F46E5") }
        return Color(hex: "#E5E7EB")
    }
}

// MARK: - Registrar Row (animation mock)

private struct RegistrarRow: View {
    let name: String
    @State private var isChecked = false

    var body: some View {
        HStack {
            Image(systemName: "server.rack")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#9CA3AF"))
            Text("Checking \(name)…")
                .font(.system(size: 13))
                .foregroundColor(Color(hex: "#6B7280"))
            Spacer()
            if isChecked {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(hex: "#22C55E"))
            } else {
                ProgressView()
                    .scaleEffect(0.7)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 38)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.3...1.2)) {
                withAnimation { isChecked = true }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DomainSearchView(vm: FunnelViewModel())
}
