//
//  OnboardingView_iPad.swift
//  Paintee
//
//  Created by Abdul Jabbar on 28/06/25.
//

import SwiftUI

struct OnboardingView_iPad: View {
    @State private var animateStars = false
    @State private var showNextView = false
    
    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(gradient: Gradient(colors: [
                Color(red: 34/255, green: 40/255, blue: 80/255),
                Color(red: 10/255, green: 20/255, blue: 50/255)
            ]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            // Star animation layer
            ForEach(0..<15, id: \.self) { index in
                Image(systemName: "sparkle")
                    .foregroundColor(.yellow.opacity(0.8))
                    .font(.system(size: CGFloat(Int.random(in: 14...24))))
                    .position(
                        x: CGFloat.random(in: 50...900),
                        y: animateStars ? CGFloat.random(in: 50...700) : CGFloat.random(in: 100...650)
                    )
                    .opacity(animateStars ? 1 : 0.2)
                    .animation(.easeInOut(duration: 2).repeatForever(), value: animateStars)
            }
            
            VStack(alignment: .center, spacing: 40) {
                // Top Image - Larger for iPad
                Image("woman")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 700, height: 700)
                    .padding(.top, 210)
        
                
                VStack(alignment: .center, spacing: 20) {
                    // Title
                    Text("Paintee")
                        .font(.system(size: 70, weight: .bold))
                        .foregroundColor(.pYellow)
                    
                    // Subtitle
                    Text("Learn to paint your face symmetrically with real-time camera guides.\nPlace dots, connect them, and follow visual steps to build your skill.")
                        .font(.system(size: 20))
                        .foregroundColor(.pCream)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 700)
                        .padding(.bottom, 70)
                }
      
                
                // Button
                Button(action: {
                    withAnimation {
                        showNextView = true
                    }
                }) {
                    Text("Let’s Get Started")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.pBlue)
                        .frame(maxWidth: 400)
                        .frame(height: 60)
                        .background(Color.pYellow)
                        .cornerRadius(20)
                        .accessibilityLabel("1. Let’s Get Started")
                        .accessibilityIdentifier("OnboardingStartButton")
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 60)
            
            if showNextView {
                NextView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            animateStars = true
        }
    }
}

#Preview {
    OnboardingView_iPad()
}
