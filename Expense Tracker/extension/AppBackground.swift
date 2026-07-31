//
//  backgroundExt.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//
import SwiftUI

extension View {
    func appBackground() -> some View {
        self.background(
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.5))
                    .frame(width: 500, height: 500)
                    .blur(radius: 120)
                    .offset(x: 130, y: -350)
            }
                .ignoresSafeArea()
        ).padding(.horizontal,8)
    }
}
#Preview{
    RootView()
}
