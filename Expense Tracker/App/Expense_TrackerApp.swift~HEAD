//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 17/07/2026.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {

    @StateObject private var router = Router()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SplashView().navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .onboarding:
                        OnboardingView()
                    }
                }
            }
            .environmentObject(router)
        }
    }
}

