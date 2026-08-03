//
//  TransButton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//


import SwiftUI

struct TransButton : View {
    let text : String
    var action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(text).foregroundStyle(.white.opacity(0.6))
                    .font(.system(size: 17, weight: .medium))
            }.padding(.horizontal,18).padding(.vertical,8).background(Color.white.opacity(0.15)).cornerRadius(30).overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(.white.opacity(0.2)))
            .buttonStyle(.plain)
        }
}
