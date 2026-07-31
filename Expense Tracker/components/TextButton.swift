//
//  TextButton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 24/07/2026.
//

import SwiftUI

struct TextButton : View {
    let text : String
    var action: () -> Void

        var body: some View {
            Button(action: action) {
                Text(text)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color.orange)
         
            
            }
            .buttonStyle(.plain)
        }
}
#Preview {
    RootView()
}
