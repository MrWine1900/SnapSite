// MARK: - FunnelProgressBar.swift
// SnapSite · Step indicator for the 3-step funnel

import SwiftUI

struct FunnelProgressBar: View {

    let currentStep: FunnelStep

    private let steps = FunnelStep.allCases

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                StepNode(
                    step: step,
                    state: nodeState(for: step)
                )
                if index < steps.count - 1 {
                    ConnectorLine(filled: step.rawValue < currentStep.rawValue)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .animation(.easeInOut(duration: 0.4), value: currentStep)
    }

    private func nodeState(for step: FunnelStep) -> NodeState {
        if step.rawValue < currentStep.rawValue  { return .completed }
        if step.rawValue == currentStep.rawValue { return .active }
        return .upcoming
    }
}

// MARK: - Node State

private enum NodeState { case completed, active, upcoming }

// MARK: - Step Node

private struct StepNode: View {
    let step: FunnelStep
    let state: NodeState

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(circleFill)
                    .frame(width: 36, height: 36)
                    .shadow(color: state == .active ? Color(hex: "#4F46E5").opacity(0.4) : .clear,
                            radius: 8, x: 0, y: 4)

                if state == .completed {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: step.icon)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(state == .active ? .white : Color(hex: "#9CA3AF"))
                }
            }

            Text(step.title)
                .font(.system(size: 10, weight: state == .active ? .bold : .regular))
                .foregroundColor(state == .active ? Color(hex: "#4F46E5") : Color(hex: "#9CA3AF"))
        }
    }

    private var circleFill: AnyShapeStyle {
        switch state {
        case .completed:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(hex: "#4F46E5"), Color(hex: "#818CF8")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .active:
            return AnyShapeStyle(
                LinearGradient(
                    colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        case .upcoming:
            return AnyShapeStyle(Color(hex: "#F3F4F6"))
        }
    }
}

// MARK: - Connector Line

private struct ConnectorLine: View {
    let filled: Bool

    var body: some View {
        Rectangle()
            .fill(
                filled
                    ? AnyShapeStyle(LinearGradient(
                        colors: [Color(hex: "#4F46E5"), Color(hex: "#818CF8")],
                        startPoint: .leading,
                        endPoint: .trailing
                      ))
                    : AnyShapeStyle(Color(hex: "#E5E7EB"))
            )
            .frame(maxWidth: .infinity)
            .frame(height: 2)
            .padding(.bottom, 20) // align with circle centre
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 24) {
        FunnelProgressBar(currentStep: .generator)
        FunnelProgressBar(currentStep: .domain)
        FunnelProgressBar(currentStep: .optimize)
    }
    .padding()
    .background(Color.white)
}
