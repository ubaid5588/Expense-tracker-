//
//  AmountInputModel.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 28/07/2026.
//

import SwiftUI
import Combine

class AmountInputModel: ObservableObject {
    @Published private(set) var rawDigits: String = ""
    
    var displayString: String {
        let digits = rawDigits.isEmpty ? "0" : rawDigits
        let padded = digits.count < 3 ? String(repeating: "0", count: 3 - digits.count) + digits : digits
        let wholePart = String(padded.dropLast(2))
        let centsPart = String(padded.suffix(2))
        let wholeInt = Int(wholePart) ?? 0
        return "\(formattedWhole(wholeInt)).\(centsPart)"
    }
    
    var decimalValue: Double {
        (Double(rawDigits) ?? 0) / 100.0
    }
    
    func reset() {
        rawDigits = ""
    }

    /// Pre-fills the model from an existing value — e.g. loading a saved budget for editing.
    func setValue(_ value: Double) {
        let cents = max(Int((value * 100).rounded()), 0)
        rawDigits = cents == 0 ? "" : String(cents)
    }
    
    func append(_ digit: String) {
        // Cap at a reasonable max (e.g. $9,999,999.99) to avoid runaway strings.
        guard rawDigits.count < 9 else { return }
        rawDigits.append(digit)
    }
    
    func delete() {
        guard !rawDigits.isEmpty else { return }
        rawDigits.removeLast()
    }
    
    private func formattedWhole(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
