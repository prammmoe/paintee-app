//
//  DrawingStepTutorialView_iPad.swift
//  Paintee
//
//  Created by Abdul Jabbar on 28/06/25.


import SwiftUI

struct DrawingStepTutorialView_iPad: View {
    @EnvironmentObject private var router: Router
    let asset: FacePaintingAsset

    private let drawingSteps: [DrawingStep] = [
        DrawingStep(title: "Place your phone\non a stable surface", imageName: "step1"),
        DrawingStep(title: "Find A Bright Spot", imageName: "step2"),
        DrawingStep(title: "Mark Your Face\nFollowing the Guide", imageName: "step3"),
        DrawingStep(title: "Connect the Dots\nand Start Drawing", imageName: "step4")
    ]

    private var gridColumns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let columnCount = screenWidth >= 1200 ? 4 : 2  // iPad Pro → 4 column, iPad normal → 2 column
        return Array(repeating: GridItem(.flexible(minimum: 150)), count: columnCount)
    }

    var body: some View {
        VStack(spacing: 40) {
            // Title
            Text("Drawing Steps")
                .font(.system(size: 60, weight: .heavy))
                .foregroundColor(Color("PYellow"))
                .padding(.top, 40)

            // Grid
            LazyVGrid(columns: gridColumns, spacing: 50) {
                ForEach(drawingSteps) { step in
                    VStack(spacing: 20) {
                        Image(step.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)

                        Text(step.title)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(.horizontal, 12)
                }
            }
            .padding(.horizontal, 80)

            Spacer()

            // Continue Button
            Button(action: {
                router.navigate(to: .dotview(asset: asset))
            }) {
                Text("Continue")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color("PYellow"))
                    .cornerRadius(18)
            }
            .padding(.horizontal, 100)
            .padding(.bottom, 50)
            .accessibilityLabel("1. Continue")
            .accessibilityIdentifier("DrawingStepsContinueButton_iPad")
        }
        .background(Color("PBlue").ignoresSafeArea())
    }
}

