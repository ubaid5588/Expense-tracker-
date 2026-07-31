//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 17/07/2026.
//

import SwiftUI
import SwiftData

@main
struct ExpenseTrackerApp: App {

    var body: some Scene {
        WindowGroup {
                SplashView()
                    }.modelContainer(for: [
                        AppUser.self,
                        Account.self,
                        Transaction.self,
                        Card.self
                    ])
                }

        }
