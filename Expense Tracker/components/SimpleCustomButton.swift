//
//  SimpleCustomButton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 21/07/2026.
//

import SwiftUI

struct SimpleCustombutton : View {
    let text : String
    var action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(text)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.orange)
                    .frame(width: 355)
                    .padding(.vertical, 15)
                    .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(.orange))
                     
            }
            .buttonStyle(.plain)
        }
}
#Preview{
    OnboardingView()
}
