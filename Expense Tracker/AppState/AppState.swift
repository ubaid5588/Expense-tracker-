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
    @Published var pendingAddAccount = false
}
