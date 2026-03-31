// MARK: - WebsiteGenerationView.swift
// SnapSite · Step 1 — Loading animation + Website preview reveal

import SwiftUI

// MARK: - Generation Loading Screen

struct WebsiteGenerationView: View {

    @ObservedObject var vm: FunnelViewModel
    @State private var particleOffset: CGFloat = 0
    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Dark gradient background
            LinearGradient(
                colors: [Color(hex: "#0F0C29"), Color(hex: "#1a1040"), Color(hex: "#24243e")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Animated particles background
            particleBackground

            // Central content
            VStack(spacing: 40) {
                Spacer()

                // Orbital loader
                orbitalLoader

                // Phase text
                VStack(spacing: 12) {
                    Text(vm.generationPhase.rawValue)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .id(vm.generationPhase.rawValue) // Force re-render for transition
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        ))
                        .animation(.easeInOut(duration: 0.4), value: vm.generationPhase)

                    Text("SnapSite AI is crafting your perfect website")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                }

                // Progress bar
                progressBar

                Spacer()
            }
            .padding(.horizontal, 40)
        }
        .onAppear {
            startAnimations()
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Orbital Loader
    // ─────────────────────────────────────────────

    private var orbitalLoader: some View {
        ZStack {
            // Outer ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#4F46E5").opacity(0.0), Color(hex: "#4F46E5")],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 3
                )
                .frame(width: 120, height: 120)
                .rotationEffect(.degrees(rotationAngle))
                .animation(.linear(duration: 1.8).repeatForever(autoreverses: false), value: rotationAngle)

            // Middle ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color(hex: "#7C3AED").opacity(0.0), Color(hex: "#7C3AED")],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-rotationAngle * 1.4))
                .animation(.linear(duration: 1.2).repeatForever(autoreverses: false), value: rotationAngle)

            // Centre logo pulse
            ZStack {
                Circle()
                    .fill(Color(hex: "#4F46E5").opacity(0.15))
                    .frame(width: 56, height: 56)
                    .scaleEffect(pulseScale)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: pulseScale
                    )

                Image(systemName: "wand.and.stars")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Progress Bar
    // ─────────────────────────────────────────────

    private var progressBar: some View {
        VStack(spacing: 8) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.08))

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color(hex: "#4F46E5"), Color(hex: "#818CF8")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(6, geo.size.width * vm.generationProgress))
                        .animation(.easeInOut(duration: 0.6), value: vm.generationProgress)
                }
            }
            .frame(height: 6)

            Text("\(Int(vm.generationProgress * 100))%")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundColor(Color.white.opacity(0.4))
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Particle Background
    // ─────────────────────────────────────────────

    private var particleBackground: some View {
        GeometryReader { geo in
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(particleColor(index: i))
                    .frame(width: particleSize(index: i), height: particleSize(index: i))
                    .position(
                        x: particleX(index: i, width: geo.size.width),
                        y: particleY(index: i, height: geo.size.height)
                    )
                    .opacity(0.3)
            }
        }
    }

    private func particleColor(index: Int) -> Color {
        [Color(hex: "#4F46E5"), Color(hex: "#7C3AED"), Color(hex: "#818CF8")][index % 3]
    }

    private func particleSize(index: Int) -> CGFloat {
        [4, 6, 3, 8, 5, 4, 6, 3][index % 8]
    }

    private func particleX(index: Int, width: CGFloat) -> CGFloat {
        width * [0.1, 0.9, 0.3, 0.7, 0.5, 0.15, 0.85, 0.45, 0.6, 0.25,
                 0.8, 0.35, 0.65, 0.2, 0.75, 0.4, 0.55, 0.05, 0.95, 0.5][index % 20]
    }

    private func particleY(index: Int, height: CGFloat) -> CGFloat {
        height * [0.1, 0.2, 0.8, 0.6, 0.4, 0.9, 0.15, 0.7, 0.35, 0.55,
                  0.25, 0.85, 0.45, 0.65, 0.05, 0.75, 0.3, 0.5, 0.95, 0.12][index % 20]
    }

    private func startAnimations() {
        rotationAngle = 360
        pulseScale = 1.2
    }
}

// MARK: - Website Preview (Post-generation)

struct WebsitePreviewView: View {

    @ObservedObject var vm: FunnelViewModel
    @State private var appeared = false
    @State private var browserBarOffset: CGFloat = -20

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Success header
                successBadge
                    .padding(.top, 24)
                    .padding(.horizontal, 20)

                // Mock browser window
                browserMockup
                    .padding(.top, 24)
                    .padding(.horizontal, 16)

                // Stats strip
                statsStrip
                    .padding(.top, 24)
                    .padding(.horizontal, 20)

                // CTA
                ctaSection
                    .padding(.top, 32)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F9FAFB").ignoresSafeArea())
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
                browserBarOffset = 0
            }
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Success Badge
    // ─────────────────────────────────────────────

    private var successBadge: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(hex: "#DCFCE7"))
                    .frame(width: 44, height: 44)
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "#16A34A"))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Your website is ready!")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Text("AI generated · Review your preview below")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#6B7280"))
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
    }

    // ─────────────────────────────────────────────
    // MARK: Browser Mockup
    // ─────────────────────────────────────────────

    private var browserMockup: some View {
        VStack(spacing: 0) {
            // Browser chrome
            browserChrome

            // Website content area
            websiteContent
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.black.opacity(0.12), radius: 20, x: 0, y: 10)
        .scaleEffect(appeared ? 1 : 0.95)
        .opacity(appeared ? 1 : 0)
    }

    private var browserChrome: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                // Traffic lights
                Circle().fill(Color(hex: "#FF5F57")).frame(width: 12, height: 12)
                Circle().fill(Color(hex: "#FFBD2E")).frame(width: 12, height: 12)
                Circle().fill(Color(hex: "#28CA41")).frame(width: 12, height: 12)

                Spacer()

                // Address bar
                HStack(spacing: 6) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color(hex: "#22C55E"))

                    Text(urlBarText)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#374151"))
                        .lineLimit(1)
                }
                .padding(.horizontal, 10)
                .frame(height: 26)
                .background(Color(hex: "#F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 6))

                Spacer()

                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(Color(hex: "#1C1C1E"))
        }
    }

    private var urlBarText: String {
        let name = vm.businessInfo.businessName
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
        return "www.\(name.isEmpty ? "yoursite" : name).com"
    }

    private var websiteContent: some View {
        VStack(spacing: 0) {
            // Navigation bar
            mockNavBar

            // Hero section
            mockHero

            // Feature strip
            mockFeatureStrip

            // Footer
            mockFooter
        }
    }

    private var mockNavBar: some View {
        HStack {
            Text(vm.businessInfo.businessName.isEmpty ? "YourBrand" : vm.businessInfo.businessName)
                .font(.system(size: 14, weight: .black))
                .foregroundColor(Color(hex: "#111827"))

            Spacer()

            HStack(spacing: 16) {
                ForEach(["Home", "About", "Contact"], id: \.self) { item in
                    Text(item)
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#6B7280"))
                }
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 44)
        .background(Color.white)
    }

    private var mockHero: some View {
        ZStack {
            LinearGradient(
                colors: [vm.businessInfo.primaryColor, vm.businessInfo.primaryColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 160)

            VStack(spacing: 8) {
                Text(vm.businessInfo.businessName.isEmpty ? "Your Brand" : vm.businessInfo.businessName)
                    .font(.system(size: 22, weight: .black))
                    .foregroundColor(.white)
                Text(vm.businessInfo.tagline.isEmpty
                     ? "Professional · Modern · Powerful"
                     : vm.businessInfo.tagline)
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Capsule()
                    .fill(Color.white)
                    .frame(width: 80, height: 28)
                    .overlay(
                        Text("Get Started")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(vm.businessInfo.primaryColor)
                    )
            }
        }
    }

    private var mockFeatureStrip: some View {
        HStack(spacing: 0) {
            ForEach(["⚡️ Fast", "📱 Mobile", "🔒 Secure", "🎨 Custom"], id: \.self) { feature in
                Text(feature)
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#374151"))
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 36)
        .background(Color(hex: "#F9FAFB"))
    }

    private var mockFooter: some View {
        HStack {
            Text("© 2025 \(vm.businessInfo.businessName.isEmpty ? "YourBrand" : vm.businessInfo.businessName)")
                .font(.system(size: 9))
                .foregroundColor(Color(hex: "#9CA3AF"))
            Spacer()
            Text("Made with SnapSite")
                .font(.system(size: 9))
                .foregroundColor(Color(hex: "#9CA3AF"))
        }
        .padding(.horizontal, 16)
        .frame(height: 30)
        .background(Color(hex: "#111827"))
    }

    // ─────────────────────────────────────────────
    // MARK: Stats Strip
    // ─────────────────────────────────────────────

    private var statsStrip: some View {
        HStack(spacing: 0) {
            StatPill(value: "100", label: "PageSpeed", icon: "bolt.fill", color: Color(hex: "#16A34A"))
            Divider().frame(height: 36)
            StatPill(value: "A+", label: "SEO Ready", icon: "magnifyingglass", color: Color(hex: "#2563EB"))
            Divider().frame(height: 36)
            StatPill(value: "SSL", label: "Secured", icon: "lock.fill", color: Color(hex: "#7C3AED"))
        }
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
    }

    // ─────────────────────────────────────────────
    // MARK: CTA
    // ─────────────────────────────────────────────

    private var ctaSection: some View {
        VStack(spacing: 12) {
            PrimaryButton(
                title: "Claim My Domain →",
                icon: nil,
                action: vm.proceedToDomain
            )

            Text("Next: choose the perfect domain for your site")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .multilineTextAlignment(.center)
        }
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
    }
}

// MARK: - Stat Pill

private struct StatPill: View {
    let value: String
    let label: String
    let icon : String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(color)
                Text(value)
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(Color(hex: "#111827"))
            }
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(Color(hex: "#9CA3AF"))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Previews

#Preview("Loading") {
    let vm = FunnelViewModel()
    vm.generationPhase = .designing
    vm.generationProgress = 0.55
    return WebsiteGenerationView(vm: vm)
}

#Preview("Preview") {
    let vm = FunnelViewModel()
    vm.businessInfo.businessName = "Bella Cucina"
    vm.businessInfo.tagline = "Authentic Italian flavours since 1998"
    vm.generatedWebsite = GeneratedWebsite.mock(for: vm.businessInfo)
    vm.showWebsitePreview = true
    return WebsitePreviewView(vm: vm)
}
