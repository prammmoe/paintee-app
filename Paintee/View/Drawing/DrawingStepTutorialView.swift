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
    let imageName: String
}

let drawingSteps: [DrawingStep] = [
    DrawingStep(title: "Place your phone\non a stable surface", imageName: "step1"),
    DrawingStep(title: "Find A Bright Spot", imageName: "step2"),
    DrawingStep(title: "Mark Your Face\nFollowing the Guide", imageName: "step3"),
    DrawingStep(title: "Connect the Dots\nand Start Drawing", imageName: "step4")
]

struct DrawingStepTutorialView: View {
    @EnvironmentObject private var router: Router
    let asset: FacePaintingAsset

    var body: some View {
        VStack(spacing: 24) {
            // Back Button
            HStack {
                Button(action: {
                    router.goBack()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                }
                Spacer()
                    .accessibilityLabel("2. Back")
                    .accessibilityIdentifier("DrawingStepsBackButton")
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)

            // Title
            Text("Drawing Steps")
                .font(.system(size: 36, weight: .heavy))
                .foregroundColor(Color("PYellow"))
                .padding(.top, 5)

            // Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 30) {
                ForEach(drawingSteps) { step in
                    VStack(spacing: 15) {
                        Image(step.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                         

                        Text(step.title)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 18)
            
            Spacer()

            Button(action: {
                router.navigate(to: .dotview(asset: asset))
            }) {
                Text("Continue")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("PYellow"))
                    .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .accessibilityLabel("1. Continue")
            .accessibilityIdentifier("DrawingStepsContinueButton")
        }
        .background(Color("PBlue").ignoresSafeArea())
    }
}
