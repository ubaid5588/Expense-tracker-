//
//  History.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 24/07/2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query var transactions: [Transaction]
    @State private var selectedRange = "Today"

    /// Transactions filtered down to the date range chosen in the picker.
    private var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()

        switch selectedRange {
        case "Today":
            return transactions.filter { calendar.isDateInToday($0.date) }

        case "Last 7 Days":
            guard let cutoff = calendar.date(byAdding: .day, value: -7, to: now) else { return transactions }
            return transactions.filter { $0.date >= cutoff }

        case "Last 30 Days":
            guard let cutoff = calendar.date(byAdding: .day, value: -30, to: now) else { return transactions }
            return transactions.filter { $0.date >= cutoff }

        default:
            return transactions
        }
    }

    var body: some View {
        VStack {
            CustomText(text: "Transaction History", fontSize: 20)

            VStack {
                HStack {
                    Spacer()
                    PickerDropdown(selection: $selectedRange)
                }
                .padding(.top, 14)
                .padding(.horizontal, 14)

                if filteredTransactions.isEmpty {
                    VStack(spacing: 8) {
                        Spacer()
                        Text("No transactions")
                            .foregroundStyle(.white.opacity(0.5))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(filteredTransactions) { trans in
                                TransactionCard(title: trans.title, amount: trans.amount, note: "", date: trans.date, isAdd: trans.isAdd)
                            }
                        }
                    }
                    .padding(.all, 8)
                }

                Spacer()
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(18)
            .appBackground()
        }
    }
}

struct PickerDropdown: View {
    @Binding var selection: String
    let options = ["Today", "Last 7 Days", "Last 30 Days"]

    var body: some View {
        Picker("Select Range", selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
        .pickerStyle(.segmented)
    }
}

    #Preview {
        HistoryView()
    }

