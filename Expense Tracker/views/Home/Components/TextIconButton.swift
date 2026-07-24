//
//  IconButton.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//


import SwiftUI

struct TextIconbutton : View {
    let icon : String
    let action : () -> Void
    let text : String
    var body : some View {
    
        VStack{
            Button(action : action){
                Image(systemName: icon).fontWeight(.semibold).foregroundStyle(.white).frame(width: 50,height: 50).background(Color.white.opacity(0.25)).clipShape(Circle())
            }
            Text(text).fontWidth(.condensed).foregroundStyle(.white)
        }
    }
}

