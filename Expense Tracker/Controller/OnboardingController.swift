import SwiftUI
import Combine

class CounterController: ObservableObject {
    @Published private(set) var counter = Counter()
    @Published var goToRootView = false
    @AppStorage("isOnboardinCompleted") var isOnboardinCompleted = false

   

    func next() {
        if counter.count < 2 {
            counter.count += 1
        }else{
            isOnboardinCompleted = true
            goToRootView = true
            
        }
    }

    func back() {
        if counter.count >= 1 {
            counter.count -= 1
        }
    }

    func skip() {
        isOnboardinCompleted = true
        goToRootView = true
        
    }
}
