//
//  Router.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 21/07/2026.
//

import SwiftUI
import Combine

class Router : ObservableObject {
    @Published var path = NavigationPath()
    
        func push(_ screen: Screen) {
            path.append(screen)
        }
    
    func pushAndRemoveAll(_ screen: Screen) {
            path = NavigationPath()
            path.append(screen)     
        }

        func pop() {
            path.removeLast()
        }

        func popToRoot() {
            path = NavigationPath()
        }
    
}

