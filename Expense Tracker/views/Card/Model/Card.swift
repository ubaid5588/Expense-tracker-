//
//  Card.swift
//  Expense Tracker
//
//  SwiftData model for a stored credit/debit card.
//
import Foundation
import SwiftData

@Model
final class Card {
    var number: String
    var holderName: String
    var cvv: String
    var validThru: String
    var clubName: String
    var dateAdded: Date

    init(
        number: String,
        holderName: String,
        cvv: String,
        validThru: String,
        clubName: String,
        dateAdded: Date = .now
    ) {
        self.number = number
        self.holderName = holderName
        self.cvv = cvv
        self.validThru = validThru
        self.clubName = clubName
        self.dateAdded = dateAdded
    }
}
