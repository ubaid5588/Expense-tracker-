//
//  History.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 24/07/2026.
//

import SwiftUI

struct History : View {
    let transactions : [Transaction] = [
        Transaction(image: "GH", title: "Added via Credit Card", subtitle: "Dec, 26, 2026", amount: 98.43,idAdd : false),
        Transaction(image: "GH", title: "Added via Credit Card", subtitle: "Dec, 26, 2026", amount: 98.43,idAdd : true),
        Transaction(image: "GH", title: "Added via Credit Card", subtitle: "Dec, 26, 2026", amount: 98.43,idAdd : false)
    ]
    var body : some View {
        ScrollView{
            LazyVStack{
                ForEach(transactions){
                    trans in
                    TransactionCard(image: trans.image, title: trans.title, subtitle: trans.subtitle, amount: trans.amount,isAdd: trans.idAdd)
                    
                }
            }
        }.navigationTitle("Transaction History").navigationBar
    }
}
#Preview {
    RootView()
}
