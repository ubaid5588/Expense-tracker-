import SwiftUI
 
struct CircularBudgetRing: View {
    let spent: Double
    let limit: Double?
    var diameter: CGFloat = 240
    var lineWidth: CGFloat = 22
 
    private var percentage: Double {
        guard let limit, limit > 0 else { return 0 }
        return spent / limit
    }
 
    private var ringFraction: Double {
        min(max(percentage, 0), 1)
    }
 
    private var ringColor: Color {
        switch percentage {
        case ..<0.7: return .green
        case 0.7..<1.0: return .orange
        default: return .red
        }
    }
 
    var body: some View {
        ZStack {
            Circle()
                .stroke(Theme.cardBorder, lineWidth: lineWidth)
 
            Circle()
                .trim(from: 0, to: ringFraction)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.6), value: ringFraction)
                .shadow(color: ringColor.opacity(0.4), radius: 8)
 
            VStack(spacing: 4) {
                Text("\(Int((percentage * 100).rounded()))%")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(Theme.primaryText)
 
                Text(limit == nil ? "No budget set" : "of monthly budget")
                    .font(.system(size: 13))
                    .foregroundColor(Theme.secondaryText)
            }
        }
        .frame(width: diameter, height: diameter)
    }
}
 
#Preview {
    VStack(spacing: 30) {
        CircularBudgetRing(spent: 320, limit: 1000)
        CircularBudgetRing(spent: 1150, limit: 1000)
    }
    .padding()
    .background(Theme.background)
}
