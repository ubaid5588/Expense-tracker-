import SwiftUI

struct TransactionCard: View {
    var title: String
    var amount: Double
    var note: String
    var date: Date
    var isAdd: Bool

  
    private var displayName: String {
        let words = title.split(separator: " ")
        guard words.count > 2 else { return title }
        return words.dropFirst(2).joined(separator: " ")
    }


    private var iconName: String {
        let name = displayName.lowercased()

        guard !name.isEmpty else { return "person.crop.circle.fill" }

        let marketKeywords = ["market", "grocery", "store", "mart", "supermarket"]
        let cardKeywords = ["card", "bank", "visa", "mastercard", "credit", "debit"]
        let foodKeywords = ["restaurant", "cafe", "coffee", "diner", "eatery"]
        let transportKeywords = ["uber", "taxi", "lyft", "careem", "transport", "fuel", "gas"]
        let billKeywords = ["electric", "utility", "bill", "internet", "phone", "wifi"]

        if marketKeywords.contains(where: name.contains) { return "cart.fill" }
        if cardKeywords.contains(where: name.contains) { return "creditcard.fill" }
        if foodKeywords.contains(where: name.contains) { return "fork.knife" }
        if transportKeywords.contains(where: name.contains) { return "car.fill" }
        if billKeywords.contains(where: name.contains) { return "bolt.fill" }

        return "person.fill"
    }

    var body: some View {
        HStack {
            Image(systemName: iconName)
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

            VStack(alignment: .leading) {
                CustomText(text: displayName, fontSize: 16).lineLimit(1)
                Text(date, format: .dateTime.weekday(.wide).month(.abbreviated).day().year())
            }

            Spacer()

            Text("\(isAdd ? "+" : "-")$\(abs(amount).formatted(.number.precision(.fractionLength(2))))")
                .foregroundStyle(isAdd ? .green : .red)
                .font(.title3)
        }
        .padding()
        .background(
            Color(.white.opacity(0.14)).cornerRadius(15).frame(maxWidth: .infinity)
        )
    }
}

#Preview {
    VStack(spacing: 12) {
        TransactionCard(title: "Sent to Super Market", amount: 45.20, note: "", date: .now, isAdd: false)
        TransactionCard(title: "Received from John Smith", amount: 120.00, note: "", date: .now, isAdd: true)
        TransactionCard(title: "Paid to Visa Card", amount: 300.00, note: "", date: .now, isAdd: false)
        TransactionCard(title: "Sent to xyz", amount: 10.00, note: "", date: .now, isAdd: false)
    }
    .padding()
    .background(Color.black)
}
