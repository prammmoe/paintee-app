//
//  DrawingStepsView.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 23/06/25.
//

import SwiftUI

struct DrawingStep: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
}

let drawingSteps: [DrawingStep] = [
    DrawingStep(title: "Place your phone on a stable surface",
                subtitle: "so it doesn’t wobble while you paint!",
                imageName: "surface"),
    DrawingStep(title: "Find A Bright Spot",
                subtitle: "Make Sure Your Face Shines Bright!",
                imageName: "light"),
    DrawingStep(title: "Mark Your Face by \n Following the Guide",
                subtitle: "Use the on-screen guide to dot your face",
                imageName: "mark"),
    DrawingStep(title: "Connect the Dots",
                subtitle: "Follow the Marks and Start Drawing!",
                imageName: "connect")
]

struct OnboardingDrawingStepsView: View {
    @State private var currentStep = 0

    var body: some View {
        ZStack {
            Color("blue").ignoresSafeArea()
            VStack {
                HStack {
                    Button("Back") { /* logic here */ }
                        .foregroundColor(.white)
                    Spacer()
                    Text("Drawing Steps")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
//                        .padding(.top, 10)
                    Spacer()
                    Button("Lewati") { /* logic here */ }
                        .foregroundColor(.white)
                    
                }
                .padding(.horizontal)
                .padding(.top, 20)

                TabView(selection: $currentStep) {
                    ForEach(0..<drawingSteps.count, id: \.self) { index in
                        let step = drawingSteps[index]
                        VStack(spacing: 20) {
                            Image(step.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            Text(step.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .foregroundColor(Color("yellow"))
                                .padding(.top, 20)
                                .padding(.horizontal)

                            Text(step.subtitle)
                                .font(.title3)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .frame(height: 420)

//                HStack(spacing: 10) {
//                    ForEach(0..<drawingSteps.count, id: \.self) { index in
//                        Circle()
//                            .fill(index == currentStep ? Color("yellow") : Color.gray.opacity(0.7))
//                            .frame(width: 10, height: 10)
//                    }
//                }
//                .padding(.top)
                if currentStep == drawingSteps.count - 1 {
                                    Button(action: {
                                        // action saat continue ditekan
                                    }) {
                                        Text("Continue")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color("yellow"))
                                            .cornerRadius(15)
                                            .padding(.horizontal)
                                            .padding(.top)
                                    }
                                    .padding(.bottom, 40)
                                } else {
                                    HStack(spacing: 10) {
                                        ForEach(0..<drawingSteps.count, id: \.self) { index in
                                            Circle()
                                                .fill(index == currentStep ? Color("yellow") : Color.gray.opacity(0.7))
                                                .frame(width: 10, height: 10)
                                        }
                                    }
                                    .padding(.top)
                                    .padding(.bottom, 40)
                                }
            }
        }
    }
}

#Preview {
    OnboardingDrawingStepsView()
}
