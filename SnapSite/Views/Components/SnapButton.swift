// MARK: - SnapButton.swift
// SnapSite · Reusable CTA button components

import SwiftUI

// MARK: - Primary CTA Button

struct PrimaryButton: View {
    let title   : String
    let icon    : String?
    let action  : () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.85)
                } else {
                    if let icon {
                        Image(systemName: icon)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                Group {
                    if isDisabled {
                        Color(hex: "#D1D5DB")
                    } else {
                        LinearGradient(
                            colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    }
                }
            )
            .foregroundColor(isDisabled ? Color(hex: "#9CA3AF") : .white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: isDisabled ? .clear : Color(hex: "#4F46E5").opacity(0.35),
                radius: 12, x: 0, y: 6
            )
        }
        .disabled(isDisabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}

// MARK: - Apple Pay Button (mock)

struct ApplePayButton: View {
    let amount : String
    let action : () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "applelogo")
                        .font(.system(size: 17, weight: .semibold))
                    Text("Pay \(amount)")
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(isLoading)
    }
}

// MARK: - Gold Premium CTA (Plus+ plan)

struct GoldCTAButton: View {
    let title  : String
    let action : () -> Void
    var isLoading: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#0A0A0F")))
                } else {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 15, weight: .semibold))
                    Text(title)
                        .font(.system(size: 17, weight: .bold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [Color(hex: "#D4AF37"), Color(hex: "#F5D060"), Color(hex: "#B8962E")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .foregroundColor(Color(hex: "#0A0A0F"))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(
                color: Color(hex: "#D4AF37").opacity(0.5),
                radius: 16, x: 0, y: 8
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#D4AF37").opacity(0.6), lineWidth: 1)
            )
        }
        .disabled(isLoading)
    }
}

// MARK: - Previews

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "Continue", icon: "arrow.right") {}
        PrimaryButton(title: "Loading…", icon: nil, action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", icon: nil, action: {}, isDisabled: true)
        ApplePayButton(amount: "€199") {}
        GoldCTAButton(title: "Request Exclusive Access") {}
    }
    .padding()
}
