//
//  TabView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//

import SwiftUI

struct TabViewBar: View {

    @State private var selectedTab = 0

    var body: some View {

        TabView(selection: $selectedTab) {

            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            TransactionView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Transaction", systemImage: "arrow.left.arrow.right")
                }
                .tag(1)

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
                .tag(2)

            SettingView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .tint(.orange)
        .environmentObject(AppState())   // <- injected once here
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
