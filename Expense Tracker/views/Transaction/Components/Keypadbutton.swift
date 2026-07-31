//
//  Keypadbutton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 28/07/2026.
//

import SwiftUI

struct KeypadButton: View {
 
    enum Kind: Equatable {
        case digit(String)
        case decimal
        case delete
    }
 
    let kind: Kind
    var action: () -> Void
 
    private var label: String {
        switch kind {
        case .digit(let value): return value
        case .decimal: return "."
        case .delete: return ""
        }
    }
 
    private var foregroundColor: Color {
        switch kind {
        case .delete: return Theme.accent
        default: return Theme.primaryText
        }
    }
 
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            action()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.keyBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Theme.keyBorder, lineWidth: 1)
                    )
 
                if kind == .delete {
                    Image(systemName: "delete.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(foregroundColor)
                } else {
                    Text(label)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(foregroundColor)
                }
            }
        }
        .frame(height: 78)
        .buttonStyle(KeypadButtonStyle())
    }
}

private struct KeypadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
