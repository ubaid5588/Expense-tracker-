//
//  SegmentedRing.swift
//  Expense Tracker
//
//  A big ring made of multiple colored arc segments, each sized by its
//  percentage of the whole (e.g. one segment per account).
//
import SwiftUI

struct RingSlice: Identifiable {
    let id = UUID()
    let name: String
    let amount: Double
    let percentage: Double   // 0...1
    let color: Color
}

struct SegmentedRing: View {
    let slices: [RingSlice]
    var diameter: CGFloat = 240
    var lineWidth: CGFloat = 26

    private var totalAmount: Double {
        slices.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.08), lineWidth: lineWidth)

            ForEach(Array(slices.enumerated()), id: \.element.id) { index, slice in
                let start = slices.prefix(index).reduce(0) { $0 + $1.percentage }
                let end = start + slice.percentage

                Circle()
                    .trim(from: start, to: max(end, start + 0.0015)) // tiny minimum so slivers stay visible
                    .stroke(slice.color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: slice.percentage)
            }

            VStack(spacing: 4) {
                Text("$\(totalAmount.formatted(.number.precision(.fractionLength(2))))")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("This Month")
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
        .frame(width: diameter, height: diameter)
    }
}
