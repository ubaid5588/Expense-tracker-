//
//  MonthlyBudget.swift
//  Expense Tracker
//
//  A single stored record holding the user's monthly spending limit.
//
import Foundation
import SwiftData

@Model
final class MonthlyBudget {
    var limit: Double
    var updatedAt: Date

    init(limit: Double, updatedAt: Date = .now) {
        self.limit = limit
        self.updatedAt = updatedAt
    }
}
