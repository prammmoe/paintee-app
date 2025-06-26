//
//  OnBoardingView.swift
//  Facy
//
//  Created by Abdul Jabbar on 21/06/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var animateStars = false
    @State private var showNextView = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color(red: 34/255, green: 40/255, blue: 80/255), Color(red: 10/255, green: 20/255, blue: 50/255)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            ForEach(0..<10, id: \.self) { index in
                Image(systemName: "sparkle")
                    .foregroundColor(.yellow.opacity(0.8))
                    .font(.system(size: CGFloat(Int.random(in: 10...20))))
                    .position(
                        x: CGFloat.random(in: 50...350),
                        y: animateStars ? CGFloat.random(in: 50...700) : CGFloat.random(in: 100...650)
                    )
                    .opacity(animateStars ? 1 : 0.2)
                    .animation(.easeInOut(duration: 2).repeatForever(), value: animateStars)
            }
            
            VStack(alignment: .leading, spacing: 20) {
                            // Top Image
                            Image("woman") // Replace with your asset name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 360, height: 360)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 40)
                            Spacer()

                            // Title
                            Text("Paintee")
                                .font(.system(size: 40))
                                .fontWeight(.bold)
                                .foregroundColor(.pYellow)
                                .padding(.horizontal, 40)

                            // Subtitle
                            Text("Learn to paint your face symmetrically with real-time camera guides. Place dots, connect them, and follow visual steps to build your skill")
                                .font(.body)
                                .foregroundColor(.pCream)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 40)

                            Spacer()

                
                // Button
                Button(action: {
                    withAnimation {
                        showNextView = true
                    }
                }) {
                    Text("Let’s Get Started")
                        .fontWeight(.semibold)
                        .foregroundColor(.pBlue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pYellow)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
            }
            .padding(.top, 50)
            
            // Transition to next screen (placeholder view)
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

// Dummy next view for transition demo
struct NextView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Text("Next Screen")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}
#Preview {
    OnboardingView()
}
