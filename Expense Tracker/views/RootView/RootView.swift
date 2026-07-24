//
//  RootView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 22/07/2026.
//

import SwiftUI

struct RootView : View {
    var body : some View {
        VStack {
            TabViewBar()
            
        }.navigationBarBackButtonHidden(true)
    }
}
#Preview {
    RootView()
}
