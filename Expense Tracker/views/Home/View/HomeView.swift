//
//  HomeView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//
import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var selectedTab: Int
    @Query private var users: [AppUser]
    @State private var showAlert = false
    @State private var inputAccount = ""
    @State private var showAllAccountsSheet = false
    @Environment(\.modelContext) private var modelContext
    @Query var accounts: [Account]
    @Query var transactions: [Transaction]

    /// Sum of all transactions. `amount` is already signed when the transaction
    /// is created (negative for expenses, positive for income), so just add them up.
    private var totalBalance: Double {
        transactions.reduce(0) { total, transaction in
            total + transaction.amount
        }
    }

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                ProfileAvatar(uiImage: users.first?.uiImage)

                VStack(alignment: .leading) {
                    CustomText(text: "Hi \(users.first?.Name ?? "Esther"),", fontSize: 18)
                    Text(users.first != nil ? "@\(users.first!.userName)" : "Welcome Back!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            BalanceCardView(selectedTab: $selectedTab, balance: totalBalance)
            HStack {
                Text("Recent").fontDesign(.rounded).fontWeight(.medium)
                Spacer()
                TextButton(text: "See all", action: {
                    showAllAccountsSheet = true
                })
            }.padding(.all)
            HStack {
                Iconbutton(icon: "plus", action: {
                    showAlert.toggle()
                }).alert("Enter Account", isPresented: $showAlert) {
                    TextField("Name", text: $inputAccount)
                    Button("OK") {
                        let account = Account(accountName: inputAccount)
                        modelContext.insert(account)
                        do {
                            try modelContext.save()
                            print(accounts)
                        } catch {
                            print(error)
                        }
                        inputAccount = ""
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Please type account name below.")
                }
                if accounts.isEmpty {
                    CustomText(text: "No Account added", fontSize: 18).padding(.horizontal)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(accounts) { account in
                                VStack(spacing: 6) {
                                    HStack(spacing: 2) {
                                        Text(getFirstLetterOfEachWord(from: account.accountName)[0])
                                        Text(getFirstLetterOfEachWord(from: account.accountName)[1])
                                    }
                                    .fontWeight(.medium)
                                    .padding(.horizontal, 2)
                                    .frame(width: 52, height: 52)
                                    .background(Color.gray.opacity(0.3))
                                    .clipShape(Circle())

                                    Text(account.accountName.components(separatedBy: " ").first ?? "")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                    .frame(height: 70)
                }

                Spacer()
            }
            HStack {
                Text("Transactions history").fontDesign(.rounded).fontWeight(.medium)
                Spacer()
                TextButton(text: "See all", action: {
                    selectedTab = 2
                })
            }.padding(.all)
            ScrollView {
                LazyVStack {
                    ForEach(transactions) { trans in
                        TransactionCard(title: trans.title, amount: trans.amount, note: "", date: trans.date, isAdd: trans.isAdd)
                    }
                }
            }
            Spacer()
        }
        .appBackground()
        .sheet(isPresented: $showAllAccountsSheet) {
            AllAccountsSheet(accounts: accounts)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

func getFirstLetterOfEachWord(from text: String) -> [String] {

    let words = text.components(separatedBy: .whitespacesAndNewlines)

    let firstLetters = words.compactMap { word -> String? in
        guard let firstChar = word.first else { return nil }
        return String(firstChar)
    }

    return firstLetters
}

struct BalanceCardView: View {
    @Binding var selectedTab: Int
    var balance: Double
    @State private var navigateToCard: Bool = false

    /// Formats the balance like "$920,230" — grouped, no decimals, sign preserved for negatives.
    private var formattedBalance: String {
        let isNegative = balance < 0
        let magnitude = abs(balance)
        let grouped = magnitude.formatted(.number.precision(.fractionLength(0)))
        return (isNegative ? "-$" : "$") + grouped
    }

    var body: some View {
        ZStack(alignment: .topLeading) {

            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.orange),
                            Color(red: 0.72, green: 0.32, blue: 0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 380, height: 210)

            VStack(alignment: .leading, spacing: 0) {
                Text("Total Balance")
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 18)
                    .padding(.leading, 20)
                CustomText(text: formattedBalance, fontSize: 26).padding(.top, 4)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                Spacer()
                HStack(spacing: 26) {
                    TextIconbutton(icon: "plus", action: {
                        selectedTab = 1
                    }, text: "Add Money"
                    )
                    TextIconbutton(icon: "arrow.left.arrow.right", action: {
                        selectedTab = 1
                    }, text: "Send"
                    )
                    TextIconbutton(icon: "creditcard", action: {
                        navigateToCard.toggle()
                    }, text: "Card"
                    )
                    TextIconbutton(icon: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90", action: {
                        selectedTab = 2
                    }, text: "History"
                    )

                }
                .padding(.leading, 38)
                .padding(.bottom, 26)
            }
            .frame(width: 340, height: 210, alignment: .topLeading)
            .navigationDestination(isPresented: $navigateToCard) {
                CardView()
            }
        }
        .frame(width: 340, height: 210)
    }
}

// MARK: - All Accounts Bottom Sheet

struct AllAccountsSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let accounts: [Account]

    @State private var accountPendingDeletion: Account?

    var body: some View {
        NavigationStack {
            Group {
                if accounts.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 36))
                            .foregroundStyle(.secondary)
                        Text("No accounts added")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    List {
                        ForEach(accounts) { account in
                            HStack(spacing: 14) {
                                HStack(spacing: 2) {
                                    Text(getFirstLetterOfEachWord(from: account.accountName).first ?? "")
                                    if getFirstLetterOfEachWord(from: account.accountName).count > 1 {
                                        Text(getFirstLetterOfEachWord(from: account.accountName)[1])
                                    }
                                }
                                .fontWeight(.medium)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.3))
                                .clipShape(Circle())

                                Text(account.accountName)
                                    .font(.body)

                                Spacer()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    accountPendingDeletion = account
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    accountPendingDeletion = account
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("All Accounts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .confirmationDialog(
                "Delete this account?",
                isPresented: Binding(
                    get: { accountPendingDeletion != nil },
                    set: { isPresented in
                        if !isPresented { accountPendingDeletion = nil }
                    }
                ),
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let account = accountPendingDeletion {
                        delete(account)
                    }
                    accountPendingDeletion = nil
                }
                Button("Cancel", role: .cancel) {
                    accountPendingDeletion = nil
                }
            } message: {
                Text("This will permanently remove \"\(accountPendingDeletion?.accountName ?? "")\".")
            }
        }
    }

    private func delete(_ account: Account) {
        withAnimation {
            modelContext.delete(account)
            try? modelContext.save()
        }
    }
}

struct ProfileAvatar: View {
    let uiImage: UIImage?
    var size: CGFloat = 53

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(.unnknown)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .padding(size * 0.3)
                    .background(Color.gray.opacity(0.3))
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
}

#Preview {
    RootView()
}
