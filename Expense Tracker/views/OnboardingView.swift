//
//  OnboardingScreen.swift
//  Expense Tracker
//
//  Created by Muhammad Ubaid on 20/07/2026.
//
import SwiftUI

struct OnboardingView : View {
    @StateObject private var controller = CounterController()
    let onboarding : [OnboardingModel] = [
        OnboardingModel(image: .onboarding1, title: "Keep Your Credit Card Information Organized", subtitle: "Securely save your credit card details for quick reference whenever you need them. Your information stays private on your device."),
        OnboardingModel(image: .onboarding2, title: "Take Control of Your Daily Spending", subtitle: "Record your income and expenses in seconds, and always know where your money goes."),
        OnboardingModel(image: .onboarding3, title: "Build Better Financial Habits Every Month", subtitle: "Set budgets, monitor your spending, and stay on track to reach your financial goals.")
    ]
    var body : some View {
        VStack{
            HStack(){
                Spacer()
                Button("Skip"){
                
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
                            })
            
            
            Custombutton(text: controller.counter.count == 2 ? "Get Started" : "Next", action:{
                controller.next()
            })
            
            if(controller.counter.count > 0){
                SimpleCustombutton(text: "Back", action: {
                    controller.back()
                })}
               
            
           
            
        }.navigationBarBackButtonHidden(true)
    }
    private var card: some View {
        ZStack(alignment: .topLeading) {
        
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 255/255, green: 106/255, blue: 13/255),
                            Color(red: 0.72, green: 0.32, blue: 0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 340, height: 210)
            
            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 160, height: 160)
                .offset(x: 240, y: -60)
                .frame(width: 340, height: 210, alignment: .topLeading)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Aurex")
                    .font(.system(size: 26, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 26)
                    .padding(.leading, 24)
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<3) { _ in
                        HStack(spacing: 5) {
                            ForEach(0..<4) { _ in
                                Circle()
                                    .fill(Color.white.opacity(0.85))
                                    .frame(width: 5, height: 5)
                            }
                        }
                    }
                    Text("5421")
                        .font(.system(size: 18, weight: .medium, design: .monospaced))
                        .kerning(2)
                        .foregroundColor(.white.opacity(0.95))
                        .padding(.leading, 4)
                }
                .padding(.leading, 24)
                .padding(.bottom, 30)
            }
            .frame(width: 340, height: 210, alignment: .topLeading)
            
            HStack(spacing: -14) {
                Circle()
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 34, height: 34)
                Circle()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 34, height: 34)
            }
            .frame(width: 310, height: 186, alignment: .bottomTrailing)

        }
        .frame(width: 340, height: 210)
        
    }}

#Preview{
    
}
