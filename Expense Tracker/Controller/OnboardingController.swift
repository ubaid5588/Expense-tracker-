//
//  OnboardingController.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 22/07/2026.
//

import SwiftUI
import Combine

class CounterController: ObservableObject {

    @Published private(set) var counter = Counter()

    func next() {
        if counter.count < 2{
            counter.count += 1
        }
    }

    func back() {
        if counter.count >= 1{
            counter.count -= 1
        }
    }

    func skip() {
        // move home screen
    }
}
