import SwiftUI

 

 
struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: Int) { self.state = UInt64(bitPattern: Int64(seed)) &+ 0x9E3779B97F4A7C15 }
    mutating func next() -> UInt64 {
        state ^= state << 13
        state ^= state >> 7
        state ^= state << 17
        return state
    }
}
 
 
struct ChipIcon: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Color(white: 0.92), Color(white: 0.72)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 44, height: 34)
            .overlay(
                VStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle().fill(Color.black.opacity(0.35)).frame(height: 1)
                    }
                }
                .padding(.horizontal, 4)
            )
            .overlay(
                HStack(spacing: 4) {
                    ForEach(0..<2, id: \.self) { _ in
                        Rectangle().fill(Color.black.opacity(0.35)).frame(width: 1)
                    }
                }
                .padding(.vertical, 4)
            )
    }
}
 
 
struct PaymentNetworkMark: View {
    var body: some View {
        HStack(spacing: -14) {
            Circle().fill(Color(red: 0.85, green: 0.15, blue: 0.2)).frame(width: 34, height: 34)
            Circle().fill(Color(red: 0.98, green: 0.75, blue: 0.15)).frame(width: 34, height: 34).opacity(0.9)
        }
        .overlay(
            Text("Pay")
                .font(.system(size: 9, weight: .semibold))
                .foregroundColor(.white)
                .offset(y: 20)
        )
    }
}

 
struct CreditCardView: View {
 
   
    let number: String
    let holderName: String
    let cvv: String
    let validThru: String
 
    // MARK: Optional inputs
    var clubName: String = "CLUB NAME"
    var seed: Int = Int.random(in: 0...9999)
 
    private var numberGroups: [String] {
        let digitsOnly = number.filter { $0.isNumber }
        return stride(from: 0, to: digitsOnly.count, by: 4).map { start in
            let startIndex = digitsOnly.index(digitsOnly.startIndex, offsetBy: start)
            let endIndex = digitsOnly.index(startIndex, offsetBy: 4, limitedBy: digitsOnly.endIndex) ?? digitsOnly.endIndex
            return String(digitsOnly[startIndex..<endIndex])
        }
    }
 
    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 0.55, green: 0.10, blue: 0.35),
                    Color(red: 0.30, green: 0.10, blue: 0.55),
                    Color(red: 0.20, green: 0.25, blue: 0.65)
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )

 
            VStack(alignment: .leading, spacing: 0) {
               
                HStack(alignment: .top) {
                    ChipIcon()
                    Spacer()
                    Text(clubName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(1)
                }
 
                Spacer(minLength: 18)
 
               
                HStack(spacing: 14) {
                    ForEach(Array(numberGroups.enumerated()), id: \.offset) { _, group in
                        Text(group)
                            .font(.system(size: 24, weight: .semibold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }
                .shadow(color: .black.opacity(0.25), radius: 1, x: 0, y: 1)
 
                Text(cvv)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.85))
                    .padding(.top, 2)
 
                Spacer(minLength: 14)
 
                // Valid thru
                HStack(alignment: .bottom, spacing: 6) {
                    Text("VALID\nTHRU")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(.white.opacity(0.75))
                        .lineSpacing(1)
                    Text(validThru)
                        .font(.system(size: 16, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                }
 
                Spacer(minLength: 14)
 
               
                HStack(alignment: .center) {
                    Text(holderName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .tracking(1.5)
 
                    Spacer()
 
                    PaymentNetworkMark()
                        .padding(.bottom, 8)
                }
            }
            .padding(20)
        }
        .frame(width: 380, height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.4), radius: 16, x: 0, y: 10)
    }
}

#Preview {
    CardView()
}
