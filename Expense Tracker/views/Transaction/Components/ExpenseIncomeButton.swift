//
//  ExpenseIncomeButton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 28/07/2026.
//

import SwiftUI

struct ExpenseIncomeButton : View {
    let text : String
    let icon : String
    let color : Color
    let isIncome : Bool
    let isActive : Bool
    let action : () -> Void
    var body : some View {
        Button(action : action){
            HStack{
                Image(systemName: icon).foregroundStyle(isActive ? .white : .gray)
                Text(text).foregroundStyle(isActive ? .white : .gray).font(.system(.title2))
            }.frame(width: 170,height: 50).background(
                !isActive ?   Color.orange.opacity(0.0) : !isIncome ? Color.pink.opacity(0.8) : Color.green
            ).cornerRadius(12) .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(isActive  ? .pink.opacity(0.5) : Color.orange))
        }
    }
}

#Preview{
    TransactionView()
}
