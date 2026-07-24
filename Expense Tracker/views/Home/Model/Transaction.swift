//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 23/07/2026.
//

import SwiftUI

struct Transaction : Identifiable {
    let id = UUID()
    let image : String
    let title : String
    let subtitle : String
    let amount : Double
    let idAdd : Bool
}
