//
//  TransactionView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 28/07/2026.
//

import SwiftUI
import SwiftData

enum Theme {
    static let background = Color(red: 0.07, green: 0.04, blue: 0.02)
    static let cardBackground = Color(red: 0.16, green: 0.09, blue: 0.05)
    static let cardBorder = Color(red: 0.32, green: 0.18, blue: 0.10)
    static let accent = Color(red: 0.90, green: 0.55, blue: 0.32)       // orange ($ sign, delete icon)
    static let primaryText = Color(red: 0.97, green: 0.94, blue: 0.90)
    static let secondaryText = Color(red: 0.62, green: 0.54, blue: 0.48)
    static let keyBackground = Color(red: 0.14, green: 0.08, blue: 0.045)
    static let keyBorder = Color(red: 0.30, green: 0.17, blue: 0.09)
}

struct TransactionView: View {
    @State private var isIncomeButton: Bool = false
    @StateObject private var amountModel = AmountInputModel()
    @State private var showCategoryPicker = false
    @Environment(\.modelContext) private var modelContext
    @Query var accounts: [Account]
    @State private var selection = "Select Account"
    @State private var showSuccessAnimation = false

    var body: some View {
        VStack {
            CustomText(text: "Transaction", fontSize: 20)

            VStack {
                HStack {
                    ExpenseIncomeButton(text: "Expense", icon: "arrow.up", color: Color.orange, isIncome: false, isActive: !isIncomeButton, action: {
                        isIncomeButton.toggle()
                    })
                    ExpenseIncomeButton(text: "Income", icon: "arrow.down", color: Color.orange, isIncome: true, isActive: isIncomeButton, action: {
                        isIncomeButton.toggle()
                    })
                }
                AmountCardView(displayAmount: amountModel.displayString)
                if accounts.isEmpty {
                    CustomText(text: "No Account added", fontSize: 20).padding(.horizontal)
                } else {
                    Menu {
                        ForEach(accounts, id: \.self) { account in
                            Button {
                                selection = account.accountName
                            } label: {
                                Text(account.accountName)
                            }
                        }
                    } label: {
                        CategoryRowView(category: selection)
                    }
                }

                KeypadView(
                    onDigit: { digit in amountModel.append(digit) },
                    onDecimal: { /* amounts are cents-based; decimal key reserved for future free-form entry */ },
                    onDelete: { amountModel.delete() }
                )
                Custombutton(text: "Add Transaction", action: {
                    addTransaction()
                }).padding(.top, 8)
                Spacer()
            }
            .appBackground()
        }
        // Default the account picker to the first available account.
        .onAppear { useFirstAccountIfNeeded() }
        .onChange(of: accounts.count) { _, _ in useFirstAccountIfNeeded() }
        .overlay {
            if showSuccessAnimation {
                SuccessCheckmarkView()
            }
        }
    }
    

    private func useFirstAccountIfNeeded() {
        guard selection == "Select Account", let first = accounts.first else { return }
        selection = first.accountName
    }

    private func addTransaction() {
        guard amountModel.decimalValue > 0 else { return }

        let addTransaction = Transaction(
            title: !isIncomeButton ? "Sent to \(selection)" : "Received from \(selection)",
            date: .now,
            note: "Sent to received from person",
            amount: !isIncomeButton ? -(amountModel.decimalValue) : +(amountModel.decimalValue),
            isAdd: isIncomeButton ? true : false
        )
        modelContext.insert(addTransaction)

        // Clear the amount back to $0.00.
        amountModel.reset()

        // Show a brief success animation, then auto-dismiss.
        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
            showSuccessAnimation = true
        }
        Task {
            try? await Task.sleep(nanoseconds: 900_000_000) // 0.9s
            withAnimation(.easeOut(duration: 0.25)) {
                showSuccessAnimation = false
            }
        }
    }
}

/// A brief scale + fade checkmark shown after a transaction is saved.
struct SuccessCheckmarkView: View {
    @State private var animateIn = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.green)
                    .scaleEffect(animateIn ? 1 : 0.5)

                Text("Transaction Added")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primaryText)
            }
            .padding(28)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Theme.cardBorder, lineWidth: 1)
                    )
            )
            .opacity(animateIn ? 1 : 0)
            .scaleEffect(animateIn ? 1 : 0.85)
        }
        .transition(.opacity)
        .onAppear {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                animateIn = true
            }
        }
    }
}

struct AmountCardView: View {
    let displayAmount: String

    var body: some View {
        VStack(spacing: 8) {
            Text("Amount")
                .font(.system(size: 15, weight: .regular))
                .foregroundColor(Theme.secondaryText)

            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text("$")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Theme.accent)
                Text(displayAmount)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Theme.primaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Theme.cardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(Theme.cardBorder, lineWidth: 1)
                )
        )
    }
}

struct CategoryRowView: View {
    let category: String
    var onTap: () -> Void = {}

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text("Category")
                    .font(.system(size: 16))
                    .foregroundColor(Theme.secondaryText)

                Spacer()

                Text(category)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Theme.primaryText)

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Theme.secondaryText)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Theme.cardBorder, lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct KeypadView: View {
    var onDigit: (String) -> Void
    var onDecimal: () -> Void
    var onDelete: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    private let digitRows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"]
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(digitRows.flatMap { $0 }, id: \.self) { digit in
                KeypadButton(kind: .digit(digit)) {
                    onDigit(digit)
                }
            }

            KeypadButton(kind: .decimal) {
                onDecimal()
            }

            KeypadButton(kind: .digit("0")) {
                onDigit("0")
            }

            KeypadButton(kind: .delete) {
                onDelete()
            }
        }
    }
}

#Preview {
    RootView()
}
