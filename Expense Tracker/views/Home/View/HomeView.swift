//
//  HomeView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//
import SwiftUI

struct HomeView : View {
    let transactions : [Transaction] = [
        Transaction(image: "GH", title: "Added via Credit Card", subtitle: "Dec, 26, 2026", amount: 98.43,idAdd : false),
        Transaction(image: "GH", title: "Added via Credit Card", subtitle: "Dec, 26, 2026", amount: 98.43,idAdd : true),
        Transaction(image: "GH", title: "Added via Credit Card", subtitle: "Dec, 26, 2026", amount: 98.43,idAdd : false)
    ]
    var body : some View {
        VStack{
            HStack(alignment: .center, ){
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
                    CustomText(text: "Hi Esther,", fontSize: 18)
                    Text("Welcome Back!")
                }
                Spacer()
            }
            card
            HStack{
                Text("Recent")
                Spacer()
                Text("See all")
            }.padding(.all)
            HStack{
                Iconbutton(icon: "plus", action: {})
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
                Spacer()
            }
            HStack{
                Text("Transactions history")
                Spacer()
                Text("See all")
            }.padding(.all)
            ScrollView{
                LazyVStack{
                    ForEach(transactions){
                        trans in 
                        TransactionCard(image: trans.image, title: trans.title, subtitle: trans.subtitle, amount: trans.amount,isAdd: trans.idAdd)
                        
                    }
                }
            }
        Spacer()
        }.appBackground()
    }
}

#Preview {
    RootView()
}


private var card: some View {
    ZStack(alignment: .topLeading) {
        
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(.orange),
                        Color(red: 0.72, green: 0.32, blue: 0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 380, height: 210)
        
        
        VStack(alignment: .leading, spacing: 0) {
            Text("Total Balance")
                .font(.system(size: 20, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .padding(.top, 18)
                .padding(.leading, 20)
            CustomText(text: "$920,230", fontSize: 26).padding(.top, 4)                .foregroundColor(.white)
                .padding(.leading, 20)
            Spacer()
            HStack(spacing: 22) {
                TextIconbutton(icon: "plus", action: {},text: "Add Money"
                )
                TextIconbutton(icon: "arrow.left.arrow.right", action: {},text: "Send"
                )
                TextIconbutton(icon: "creditcard", action: {},text: "Card"
                )
                TextIconbutton(icon: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90", action: {},text: "Transaction"
                )
                
            }
            .padding(.leading, 30)
            .padding(.bottom, 26)
        }
        .frame(width: 340, height: 210, alignment: .topLeading)
        
        
        
    }
    .frame(width: 340, height: 210)
}
