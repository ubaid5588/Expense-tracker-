//
//  Account.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 29/07/2026.
//
import SwiftData

@Model
class Account {
    var accountName: String

    init(accountName: String) {
        self.accountName = accountName
    }
}
