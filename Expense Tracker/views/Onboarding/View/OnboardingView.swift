//
//  OnboardingScreen.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 20/07/2026.
//
import SwiftUI

struct OnboardingView : View {
    @StateObject private var controller = CounterController()
    @AppStorage("isOnboardinCompleted") var isOnboardinCompleted = false
    
    let onboarding : [OnboardingModel] = [
        OnboardingModel(image: .onboarding1, title: "Keep Your Credit Card Information Organized", subtitle: "Securely save your credit card details for quick reference whenever you need them. Your information stays private on your device."),
        OnboardingModel(image: .onboarding2, title: "Take Control of Your Daily Spending", subtitle: "Record your income and expenses in seconds, and always know where your money goes."),
        OnboardingModel(image: .onboarding3, title: "Build Better Financial Habits Every Month", subtitle: "Monitor your spending, and stay on track to reach your financial goals.")
    ]
    var body : some View {
        NavigationStack{
            VStack{
                HStack(){
                    Spacer()
                    Button("Skip"){
                        controller.skip()
                    }.foregroundStyle(.orange).padding().background(.orange.opacity(0.3)).cornerRadius(40)
                }.frame(width: 380)
                VStack{
                    Image(onboarding[controller.counter.count].image).resizable().scaledToFit().frame(width: 250).frame(height: 220)
                    CustomText(text: onboarding[controller.counter.count].title, fontSize: 28         ).padding()
                    Text(onboarding[controller.counter.count].subtitle).multilineTextAlignment(.center).padding().foregroundStyle(.orange.opacity(1)).fontWeight(.regular)
                    
                    HStack(spacing: 12) {
                        ForEach(0..<3) { index in
                            Circle()
                                .foregroundStyle(index == controller.counter.count ? .orange : .orange.opacity(0.3))
                                .frame(width: index == controller.counter.count ? 14 : 10,
                                       height: index == controller.counter.count ? 14 : 10)
                                .scaleEffect(index == controller.counter.count ? 1.1 : 1.0)
                                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: controller.counter.count)
                        }
                    }.padding()
                }.gesture(DragGesture(minimumDistance: 50,coordinateSpace: .local).onEnded{
                    value in
                    if value.translation.width < 0 {
                        withAnimation(.bouncy){
                            controller.next()
                        }
                    }
                    else if value.translation.width > 0 {
                        withAnimation(.bouncy){
                            controller.back()
                        }
                    }
                }).navigationDestination(isPresented: $controller.goToRootView){
                    RootView()
                    
                }
                Custombutton(text: controller.counter.count == 2 ? "Get Started" : "Next", action:{
                    controller.next()
                })
                
                if(controller.counter.count > 0){
                    SimpleCustombutton(text: "Back", action: {
                        controller.back()
                    })
                }
            }
        }.navigationBarBackButtonHidden(true)
    }
}
    
