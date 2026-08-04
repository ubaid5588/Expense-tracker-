//
//  ContentView.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 17/07/2026.
//

import SwiftUI

struct SplashView: View {
    @State private var goToOnboarding = false
    @State private var goToRootView = false
    @AppStorage("isOnboardinCompleted") var isOnboardinCompleted = false
    var body: some View {
    
        NavigationStack{
            VStack {
                
                LinearGradient(
                    colors: [Color.orange.opacity(0.5), .orange],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 70, height: 70)
                .cornerRadius(12)
                .overlay {
                    Image(systemName: "wallet.bifold.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                .shadow(color: .orange, radius: 20, x: 0, y: 3)
                .padding(.bottom, 14)
                
                Text("Expense Tracker")
                    .font(.system(.title2, design: .rounded, weight: .medium))
                    .padding(.bottom, 2)
                
                Text("Track smarter. Save better.")
                    .font(.system(.headline, design: .rounded, weight: .medium))
                    .foregroundStyle(.orange.opacity(0.7))
            }
            .padding().navigationDestination(isPresented: $goToOnboarding) {
                OnboardingView()
            }.navigationDestination(isPresented: $goToRootView) {
                RootView()
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    if !isOnboardinCompleted {
                        goToOnboarding = true
                    }else{
                        goToRootView = true
                    }
                    
                }
            }
        }

    }
}
#Preview {
    SplashView()
}
