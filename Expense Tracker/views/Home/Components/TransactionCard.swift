//
//  TransactionCard.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//
import SwiftUI


struct TransactionCard : View {
    let image : String
    let title : String
    let subtitle : String
    let amount : Double
    let isAdd : Bool
    var body : some View {
        HStack{
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 21)
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
            }
            Spacer()
            Text("\(isAdd ? "+" : "-")$\(amount.formatted(.number.precision(.fractionLength(2))))").foregroundStyle(isAdd ? .green : .red).font(.title3)
        }.padding().background(
            Color(.white.opacity(0.2)).cornerRadius(10).frame(maxWidth:.infinity)
        )
    }
}

#Preview {
    RootView()
}
