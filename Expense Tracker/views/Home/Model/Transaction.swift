//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//

import SwiftData
import SwiftUI

@Model
class Transaction {
    var title : String
    var amount : Double
    var note : String
    var date : Date
    var isAdd : Bool
    init(title: String,date: Date,note : String, amount: Double, isAdd: Bool) {
        
        self.title = title
        self.amount = amount
        self.note = note
        self.date = date
        self.isAdd = isAdd
    }
}
