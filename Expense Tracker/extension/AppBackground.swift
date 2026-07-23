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
                    Color(.orange) // base dark background

                    RadialGradient(
                        colors: [Color(.orange).opacity(0.55), .clear],
                        center: .topTrailing,
                        startRadius: 10,
                        endRadius: 420
                    )
                }
                .ignoresSafeArea()
            )
        }
}
