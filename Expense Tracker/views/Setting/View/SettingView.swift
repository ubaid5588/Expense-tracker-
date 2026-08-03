//
//  ProfileView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//

import SwiftUI
import PhotosUI
import SwiftData

struct SettingView: View {
    @State private var showBottomSheet = false
    @State private var showResetConfirmation = false
    @Environment(\.modelContext) private var modelContext

    @Query private var users: [AppUser]
    @Query private var accounts: [Account]
    @Query private var transactions: [Transaction]
    @Query private var cards: [Card]

    var body: some View {
        VStack {
            CustomText(text: "Settings", fontSize: 20)
            VStack {

                VStack {
                    ListTitle(
                        image: "person.fill",
                        profileImage: users.first?.uiImage,
                        title: users.first?.Name ?? "Esther",
                        subtitle: users.first.map { "@\($0.userName)" } ?? "@devlolance",
                        amount: 98.98,
                        isAdd: true,
                        edit: { showBottomSheet.toggle() }
                    )
                }
                .sheet(isPresented: $showBottomSheet) {
                    BottomSheetContent()
                        .presentationDetents([.fraction(0.5), .large])
                        .presentationDragIndicator(.visible)
                }

                NavigationLink {
                    AccountBreakdownView()
                } label: {
                    HStack {
                        Image(systemName: "chart.pie.fill")
                            .foregroundStyle(.orange)
                        Text("Monthly Overview")
                            .foregroundStyle(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.white.opacity(0.08))
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 16)
        

                Button {
                    showResetConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash.fill")
                            .foregroundStyle(.red)
                        Text("Reset App")
                            .foregroundStyle(.red)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.red.opacity(0.12))
                    )
                }
                .buttonStyle(.plain)
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal)
            .appBackground()
        }
        .confirmationDialog(
            "Reset App?",
            isPresented: $showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Everything", role: .destructive) {
                resetApp()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently delete all accounts, transactions, cards, and your profile. This cannot be undone.")
        }
    }

    private func resetApp() {
        // Remove any saved profile photos from disk before deleting the user records.
        for user in users {
            if let path = user.profilePath {
                let url = FileManager.documentsDirectory.appendingPathComponent(path)
                try? FileManager.default.removeItem(at: url)
            }
        }

        for transaction in transactions {
            modelContext.delete(transaction)
        }
        for account in accounts {
            modelContext.delete(account)
        }
        for card in cards {
            modelContext.delete(card)
        }
        for user in users {
            modelContext.delete(user)
        }

        try? modelContext.save()
    }
}

struct BottomSheetContent: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var users: [AppUser]

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: Image? = nil
    @State private var rawImageData: Data? = nil
    @State private var name: String = ""
    @State private var userName: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Edit Profile")
                .font(.title2)
                .bold()

            HStack {
                VStack(spacing: 20) {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if let selectedImage {
                            selectedImage
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                        } else {
                            Image(systemName: "plus")
                                .foregroundStyle(.orange)
                                .font(.system(size: 30))
                                .padding()
                                .frame(width: 100, height: 100)
                                .background(Color.white.opacity(0.4))
                                .cornerRadius(22)
                        }
                    }
                    .onChange(of: selectedItem) { _, newItem in
                        Task {
                            if let newItem,
                               let data = try? await newItem.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                await MainActor.run {
                                    self.rawImageData = data
                                    self.selectedImage = Image(uiImage: uiImage)
                                }
                            }
                        }
                    }
                }
                .padding()

                VStack {
                    TextField("Enter Your Name", text: $name)
                        .textFieldStyle(.roundedBorder)
                    TextField("Enter Your User Name", text: $userName)
                        .textFieldStyle(.roundedBorder)
                }.padding(.trailing, 17)
            }

            Button(action: saveUserProfile) {
                Text("Edit Profile")
            }
            .buttonStyle(.borderedProminent)
            .disabled(name.isEmpty || userName.isEmpty)

            Spacer()
        }
        .padding(.top, 30)
        .onAppear {
            if let existing = users.first {
                name = existing.Name
                userName = existing.userName
                if let img = existing.uiImage {
                    selectedImage = Image(uiImage: img)
                }
            }
        }
    }

    private func saveUserProfile() {
        let existing = users.first
        var filenameString: String? = existing?.profilePath // keep old photo unless replaced

        if let rawImageData {
            let uniqueFilename = "profile_\(UUID().uuidString).jpg"
            let destinationURL = FileManager.documentsDirectory.appendingPathComponent(uniqueFilename)

            do {
                try rawImageData.write(to: destinationURL)

                if let oldPath = existing?.profilePath {
                    let oldURL = FileManager.documentsDirectory.appendingPathComponent(oldPath)
                    try? FileManager.default.removeItem(at: oldURL)
                }

                filenameString = uniqueFilename
            } catch {
                print("Failed writing image to Disk directory: \(error.localizedDescription)")
            }
        }

        if let existing {
            existing.Name = name
            existing.userName = userName
            existing.profilePath = filenameString
        } else {
            let newUserProfile = AppUser(Name: name, userName: userName, profilePath: filenameString)
            modelContext.insert(newUserProfile)
        }

        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
    .modelContainer(for: [AppUser.self, Account.self, Transaction.self, Card.self], inMemory: true)
}
