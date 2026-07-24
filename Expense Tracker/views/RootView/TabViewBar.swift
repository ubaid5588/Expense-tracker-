//
//  TabView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//

import SwiftUI

struct TabViewBar : View {
    var body : some View {
        TabView {
            Tab("Home",systemImage: "house"){
                HomeView()
            }
            Tab("Send",systemImage: "arrow.left.arrow.right"){
            }
            Tab("History",systemImage: "clock"){
            }
            Tab("Profile",systemImage: "person"){
            }
        }.tint(.orange)
    }
}
