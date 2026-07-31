//
//  CardView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 29/07/2026.
//
import SwiftUI
import SwiftData

struct CardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Card.dateAdded, order: .reverse) private var cards: [Card]

    @State private var showAddSheet = false
    @State private var isRevealed = false     // sensitive info hidden by default
    @State private var cardPendingDeletion: Card?

    var body: some View {
        VStack {
            if cards.isEmpty {
                Spacer()
                VStack(spacing: 8) {
                    Image(systemName: "creditcard")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.3))
                    Text("No cards yet")
                        .foregroundStyle(.white.opacity(0.5))
                }
                Spacer()
            } else {
                List {
                    ForEach(cards) { card in
                        CreditCardView(
                            number: card.number,
                            holderName: card.holderName,
                            cvv: card.cvv,
                            validThru: card.validThru,
                            clubName: card.clubName,
                            isRevealed: isRevealed
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                cardPendingDeletion = card
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                cardPendingDeletion = card
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            Spacer()
        }
        .appBackground()
        .navigationTitle("Card")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    Button {
                        withAnimation { isRevealed.toggle() }
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash" : "eye")
                            .foregroundStyle(.orange)
                    }

                    Button {
                        showAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.orange)
                            .font(.title3)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            AddCardSheet()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .confirmationDialog(
            "Delete this card?",
            isPresented: Binding(
                get: { cardPendingDeletion != nil },
                set: { isPresented in
                    if !isPresented { cardPendingDeletion = nil }
                }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let card = cardPendingDeletion {
                    delete(card)
                }
                cardPendingDeletion = nil
            }
            Button("Cancel", role: .cancel) {
                cardPendingDeletion = nil
            }
        } message: {
            Text("This will permanently remove \(cardPendingDeletion?.clubName ?? "this card") ending in \(lastFourDigits(of: cardPendingDeletion?.number ?? "")).")
        }
    }

    private func delete(_ card: Card) {
        withAnimation {
            modelContext.delete(card)
        }
    }

    private func lastFourDigits(of number: String) -> String {
        let digits = number.filter { $0.isNumber }
        return String(digits.suffix(4))
    }
}

struct AddCardSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var number: String = ""
    @State private var holderName: String = ""
    @State private var cvv: String = ""
    @State private var validThru: String = ""
    @State private var clubName: String = ""

    private var isValid: Bool {
        !number.trimmingCharacters(in: .whitespaces).isEmpty &&
        !holderName.trimmingCharacters(in: .whitespaces).isEmpty &&
        cvv.count >= 3 &&
        !validThru.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.05, blue: 0.09).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 16) {

                        CreditCardView(
                            number: number.isEmpty ? "0000 0000 0000 0000" : number,
                            holderName: holderName.isEmpty ? "NAME SURNAME" : holderName.uppercased(),
                            cvv: cvv,
                            validThru: validThru.isEmpty ? "MM/YY" : validThru,
                            clubName: clubName.isEmpty ? "CLUB NAME" : clubName
                        )
                        .scaleEffect(0.9)
                        .frame(height: 200)
                        .padding(.top, 8)

                        VStack(spacing: 14) {
                            CardFormField(label: "Club / Club Name", placeholder: "e.g. Club Name", text: $clubName)
                            CardFormField(label: "Card Number", placeholder: "1234 5678 9101 8598", text: $number, keyboard: .numberPad)
                            CardFormField(label: "Cardholder Name", placeholder: "Mira Khan", text: $holderName)

                            HStack(spacing: 14) {
                                CardFormField(label: "CVV", placeholder: "123", text: $cvv, keyboard: .numberPad)
                                CardFormField(label: "Valid Thru", placeholder: "MM/YY", text: $validThru)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Add Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.07, green: 0.05, blue: 0.09), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.white.opacity(0.7))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let card = Card(
                            number: number,
                            holderName: holderName.uppercased(),
                            cvv: cvv,
                            validThru: validThru,
                            clubName: clubName.isEmpty ? "CLUB NAME" : clubName
                        )
                        modelContext.insert(card)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isValid)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct CardFormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboard: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white.opacity(0.6))

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.white.opacity(0.3)))
                .font(.system(size: 16))
                .foregroundColor(.white)
                .keyboardType(keyboard)
                .padding(.horizontal, 14)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
        }
    }
}

#Preview {
    NavigationStack {
        CardView()
    }
    .modelContainer(for: Card.self, inMemory: true)
}
