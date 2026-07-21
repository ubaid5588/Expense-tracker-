//
//  CustomText.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 21/07/2026.
//
import SwiftUI

struct CustomText : View {
    let text : String
    let fontSize : CGFloat
   
    var body : some View {
        Text(text)
            .font(.system(size: fontSize, weight: .heavy, design: .rounded))
            .multilineTextAlignment(.center)
    }
}
