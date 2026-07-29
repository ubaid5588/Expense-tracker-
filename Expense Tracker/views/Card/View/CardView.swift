//
//  CardView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 29/07/2026.
//
import SwiftUI

struct CardView : View {
    var body : some View {
       
        VStack{
            CustomText(text: "Transaction History", fontSize: 20)
            VStack{
                HStack{
//                    Text("History").font(.system(size: 18,weight: .heavy))
//                    CustomText(text: "History", fontSize: 20)
                    Spacer()
                    
                    PickerDropdown()
                   
                }.padding(.top,14,).padding(.horizontal,14)
                
               
            }
        }
        
    }
}

    #Preview {
        CardView()
    }
