//
//  ListTitle.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 27/07/2026.
//


import SwiftUI

struct ListTitle: View {
    let image: String
    var profileImage: UIImage? = nil   // new: real photo, optional
    let title: String
    let subtitle: String
    let amount: Double
    let isAdd: Bool
    let edit: () -> Void

    var body: some View {
        HStack {
            if let profileImage {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 53, height: 53)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            } else {
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
            }

            VStack(alignment: .leading) {
                CustomText(text: title, fontSize: 16).lineLimit(1)
                Text(subtitle)
            }
            .padding(.horizontal, 10)

            Spacer()
            TransButton(text: "Edit", action: edit)
        }
        .padding()
        .background(
            Color(.white.opacity(0.14)).cornerRadius(15).frame(maxWidth: .infinity)
        )
    }
}
#Preview {
    SettingView()
}
