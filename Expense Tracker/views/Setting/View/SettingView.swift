//
//  ProfileView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//

import SwiftUI

struct ProfileView : View {
    var body: some View{
        VStack{
            ListTitle(image: "Person", title: "Esther", subtitle: "@devlolance", amount: 98.98, isAdd: true)
            Spacer()
        
        }.appBackground()
    }
}

#Preview {
    ProfileView()
}
