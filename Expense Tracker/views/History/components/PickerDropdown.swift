//
//  Datebutton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//

import SwiftUI

struct PickerDropdown: View {
    @State private var selection = "Apple"
    let fruits = ["Apple", "Banana", "Orange"]
    
    var body: some View {
        Picker("Select Fruit", selection: $selection) {
            ForEach(fruits, id: \.self) { fruit in
                Text(fruit).tag(fruit)
            }
        }
        .pickerStyle(.menu) // Forces the dropdown behavior
        .padding()
    }
}

#Preview {
    HistoryView()
}
