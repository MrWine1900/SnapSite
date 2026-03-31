// MARK: - GeneratorView.swift
// SnapSite · Step 1 — "The Wow Effect"
// User fills in basic info → AI generates a website preview

import SwiftUI
import PhotosUI

struct GeneratorView: View {

    @ObservedObject var vm: FunnelViewModel

    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showTypePicker = false
    @FocusState private var focusedField: Field?

    private enum Field { case name, tagline }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                headerSection
                    .padding(.bottom, 32)

                formSection
                    .padding(.horizontal, 20)

                Spacer(minLength: 32)

                generateButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F9FAFB").ignoresSafeArea())
        .onChange(of: selectedItems) { _, items in
            loadPhotos(from: items)
        }
        .sheet(isPresented: $showTypePicker) {
            businessTypePicker
        }
        .onTapGesture { focusedField = nil }
    }

    // ─────────────────────────────────────────────
    // MARK: Header
    // ─────────────────────────────────────────────

    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            // Gradient hero background
            LinearGradient(
                colors: [Color(hex: "#4F46E5"), Color(hex: "#7C3AED"), Color(hex: "#1E1B4B")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 220)

            // Decorative circles
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 200)
                .offset(x: 120, y: -40)

            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 140)
                .offset(x: -100, y: 20)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(hex: "#A5B4FC"))
                    Text("STEP 1 OF 3")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(hex: "#A5B4FC"))
                        .kerning(1.5)
                }

                Text("Create Your\nWebsite")
                    .font(.system(size: 34, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .lineSpacing(2)

                Text("Tell us about your business and we'll\nbuild a stunning website in seconds.")
                    .font(.system(size: 14))
                    .foregroundColor(Color.white.opacity(0.75))
                    .lineSpacing(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
        .clipShape(RoundedRectangle(cornerRadius: 0))
    }

    // ─────────────────────────────────────────────
    // MARK: Form
    // ─────────────────────────────────────────────

    private var formSection: some View {
        VStack(spacing: 20) {
            // Business Name
            SnapTextField(
                label: "Business Name",
                placeholder: "e.g. Bella Cucina",
                icon: "building.2.fill",
                text: $vm.businessInfo.businessName
            )
            .focused($focusedField, equals: .name)

            // Business Type
            Button { showTypePicker = true } label: {
                HStack(spacing: 12) {
                    Image(systemName: vm.businessInfo.businessType.icon)
                        .foregroundColor(Color(hex: "#4F46E5"))
                        .frame(width: 20)

                    Text(vm.businessInfo.businessType.rawValue)
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "#111827"))

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "#E5E7EB"), lineWidth: 1)
                )
            }

            // Tagline
            SnapTextField(
                label: "Tagline (optional)",
                placeholder: "e.g. Authentic Italian flavours since 1998",
                icon: "quote.closing",
                text: $vm.businessInfo.tagline
            )
            .focused($focusedField, equals: .tagline)

            // Photo Picker
            photoPickerSection
        }
    }

    private var photoPickerSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Photos (optional)", systemImage: "photo.stack.fill")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#374151"))

            if vm.businessInfo.photos.isEmpty {
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 6, matching: .images) {
                    VStack(spacing: 10) {
                        Image(systemName: "plus.viewfinder")
                            .font(.system(size: 28))
                            .foregroundColor(Color(hex: "#4F46E5"))
                        Text("Add photos of your business")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(Color(hex: "#EEF2FF"))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [6]))
                            .foregroundColor(Color(hex: "#818CF8"))
                    )
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(vm.businessInfo.photos) { photo in
                            Image(uiImage: photo.image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        PhotosPicker(selection: $selectedItems, maxSelectionCount: 6, matching: .images) {
                            VStack {
                                Image(systemName: "plus")
                                    .foregroundColor(Color(hex: "#4F46E5"))
                            }
                            .frame(width: 80, height: 80)
                            .background(Color(hex: "#EEF2FF"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
        }
    }

    // ─────────────────────────────────────────────
    // MARK: Generate Button
    // ─────────────────────────────────────────────

    private var generateButton: some View {
        PrimaryButton(
            title: "Generate My Website",
            icon: "wand.and.stars",
            action: vm.generateWebsite,
            isDisabled: !vm.canGenerate
        )
    }

    // ─────────────────────────────────────────────
    // MARK: Business Type Sheet
    // ─────────────────────────────────────────────

    private var businessTypePicker: some View {
        NavigationStack {
            List(BusinessType.allCases) { type in
                Button {
                    vm.businessInfo.businessType = type
                    showTypePicker = false
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: type.icon)
                            .foregroundColor(Color(hex: "#4F46E5"))
                            .frame(width: 24)
                        Text(type.rawValue)
                            .foregroundColor(Color(hex: "#111827"))
                        Spacer()
                        if vm.businessInfo.businessType == type {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(hex: "#4F46E5"))
                        }
                    }
                }
            }
            .navigationTitle("Business Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showTypePicker = false }
                }
            }
        }
        .presentationDetents([.medium])
    }

    // ─────────────────────────────────────────────
    // MARK: Photo Loading
    // ─────────────────────────────────────────────

    private func loadPhotos(from items: [PhotosPickerItem]) {
        Task {
            var loaded: [SnapPhoto] = []
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    loaded.append(SnapPhoto(image: image))
                }
            }
            await MainActor.run {
                vm.businessInfo.photos = loaded
            }
        }
    }
}

// MARK: - SnapTextField

struct SnapTextField: View {
    let label      : String
    let placeholder: String
    let icon       : String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(hex: "#374151"))

            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            text.isEmpty ? Color(hex: "#E5E7EB") : Color(hex: "#4F46E5"),
                            lineWidth: text.isEmpty ? 1 : 1.5
                        )
                )
        }
    }
}

// MARK: - Preview

#Preview {
    GeneratorView(vm: FunnelViewModel())
}
