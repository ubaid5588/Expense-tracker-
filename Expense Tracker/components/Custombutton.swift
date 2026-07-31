//
//  Custombutton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 21/07/2026.
//
import SwiftUI

struct Custombutton : View {
    let text : String
    let action : () -> Void
    var body : some View {
        Button(action : action){
            Text(text).foregroundStyle(.white)
                .font(.system(size: 18, weight: .medium)).frame(width: 355).padding(.vertical,16).background(
                    LinearGradient(
                        colors: [
                            Color(red: 255/255, green: 106/255, blue: 13/255),
                                            Color(red: 0.72, green: 0.32, blue: 0.15)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                ).cornerRadius(18)
        }
    }
}
