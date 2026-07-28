//
//  ListTitle.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//


import SwiftUI

struct ListTitle : View {
    let image : String
    let title : String
    let subtitle : String
    let amount : Double
    let isAdd : Bool
    var body : some View {
        HStack{
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white)
                .padding(16)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
            VStack(alignment: .leading){
                CustomText(text: title, fontSize: 16).lineLimit(1)
                Text(subtitle)
            }.padding(.horizontal,10)
            Spacer()
         TransButton(text: "Edit", action: {})
        }.padding().background(
            Color(.white.opacity(0.14)).cornerRadius(15).frame(maxWidth:.infinity)
        )
    }
}
#Preview {
    ProfileView()
}
