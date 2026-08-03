//
//  AppState.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 03/08/2026.
//

// AppState.swift
import SwiftUI
import Combine

class AppState: ObservableObject {
    /// Set true when TransactionView wants HomeView to pop open its "Enter Account" alert.
    @Published var pendingAddAccount = false
}
