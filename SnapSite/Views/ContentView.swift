// MARK: - ContentView.swift
// SnapSite · Root view — orchestrates the 3-step funnel

import SwiftUI

struct ContentView: View {

    @StateObject private var vm = FunnelViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            // Background
            Color(hex: "#F9FAFB").ignoresSafeArea()

            VStack(spacing: 0) {
                // Persistent top bar
                topBar

                // Step progress indicator
                FunnelProgressBar(currentStep: vm.currentStep)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)

                // Funnel body
                funnelBody
            }
        }
        .onChange(of: vm.isGenerating) { generating in
            // Nothing needed here — handled inside child views
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Top Bar
    // ─────────────────────────────────────────────

    private var topBar: some View {
        HStack(spacing: 12) {
            // Logo mark
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 32, height: 32)

                Image(systemName: "wand.and.stars")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }

            // Brand
            VStack(alignment: .leading, spacing: 1) {
                Text("SnapSite")
                    .font(.system(size: 17, weight: .black))
                    .foregroundColor(Color(hex: "#111827"))
                Text("Your Professional Website in a Snap")
                    .font(.system(size: 10))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }

            Spacer()

            // Help button
            Button {
                // In production: show help
            } label: {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(Color.white)
    }

    // ─────────────────────────────────────────────
    // MARK: Funnel Body
    // ─────────────────────────────────────────────

    @ViewBuilder
    private var funnelBody: some View {
        switch vm.currentStep {
        case .generator:
            generatorStep

        case .domain:
            DomainSearchView(vm: vm)
                .transition(funnelTransition)

        case .optimize:
            OptimizePublishView(vm: vm)
                .transition(funnelTransition)
        }
    }

    @ViewBuilder
    private var generatorStep: some View {
        if vm.isGenerating {
            WebsiteGenerationView(vm: vm)
                .transition(funnelTransition)
        } else if vm.showWebsitePreview {
            WebsitePreviewView(vm: vm)
                .transition(funnelTransition)
        } else {
            GeneratorView(vm: vm)
                .transition(funnelTransition)
        }
    }

    private var funnelTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal:   .move(edge: .leading).combined(with: .opacity)
        )
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
