//
//  AccountBreakdownView.swift
//  Expense Tracker
//
//  Shows this month's totals as a colored ring, broken down by account
//  (parsed from each transaction's title, same way TransactionCard does).
//  Toggle between Expense and Income breakdowns.
//
import SwiftUI
import SwiftData

struct AccountBreakdownView: View {
    @Query private var transactions: [Transaction]
    @State private var isIncomeSelected = false

    private let palette: [Color] = [.green, .red, .blue, .orange, .purple, .yellow, .pink, .cyan, .mint, .indigo]

    /// This calendar month's transactions matching the selected mode
    /// (isAdd == true for income, isAdd == false for expense).
    private var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        return transactions.filter {
            calendar.isDate($0.date, equalTo: now, toGranularity: .month) && $0.isAdd == isIncomeSelected
        }
    }

    /// Groups the filtered transactions by the account name embedded in the title
    /// (e.g. "Sent to Super Market" -> "Super Market"), same parsing TransactionCard uses.
    private var accountTotals: [(name: String, amount: Double)] {
        var totals: [String: Double] = [:]
        for transaction in filteredTransactions {
            let name = accountName(from: transaction.title)
            totals[name, default: 0] += abs(transaction.amount)
        }
        return totals
            .sorted { $0.value > $1.value }
            .map { (name: $0.key, amount: $0.value) }
    }

    private var totalAmount: Double {
        accountTotals.reduce(0) { $0 + $1.amount }
    }

    private var slices: [RingSlice] {
        accountTotals.enumerated().map { index, item in
            let percentage = totalAmount > 0 ? item.amount / totalAmount : 0
            return RingSlice(
                name: item.name,
                amount: item.amount,
                percentage: percentage,
                color: palette[index % palette.count]
            )
        }
    }

    private func accountName(from title: String) -> String {
        let words = title.split(separator: " ")
        guard words.count > 2 else { return title }
        return words.dropFirst(2).joined(separator: " ")
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                ExpenseIncomeButton(text: "Expense", icon: "arrow.up", color: .orange, isIncome: false, isActive: !isIncomeSelected, action: {
                    isIncomeSelected = false
                })
                ExpenseIncomeButton(text: "Income", icon: "arrow.down", color: .orange, isIncome: true, isActive: isIncomeSelected, action: {
                    isIncomeSelected = true
                })
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            if slices.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "chart.pie")
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.3))
                    Text(isIncomeSelected ? "No income this month yet" : "No expenses this month yet")
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
            } else {
                SegmentedRing(slices: slices)
                    .padding(.top, 4)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(slices) { slice in
                            HStack {
                                Circle()
                                    .fill(slice.color)
                                    .frame(width: 12, height: 12)

                                Text(slice.name)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.white)
                                    .lineLimit(1)

                                Spacer()

                                Text("$\(slice.amount.formatted(.number.precision(.fractionLength(2))))")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.6))

                                Text("\(Int((slice.percentage * 100).rounded()))%")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(slice.color)
                                    .frame(width: 44, alignment: .trailing)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(Color.white.opacity(0.06))
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .appBackground()
        .navigationTitle("Monthly Overview")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AccountBreakdownView()
    }
    .modelContainer(for: Transaction.self, inMemory: true)
}
