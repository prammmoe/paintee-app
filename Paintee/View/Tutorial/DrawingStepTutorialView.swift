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
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let asset: FacePaintingAsset

    private var isWideScreen: Bool {
        horizontalSizeClass == .regular || UIScreen.main.bounds.width > 600
    }

    private var gridColumns: [GridItem] {
        let columnCount = isWideScreen ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: columnCount)
    }

    var body: some View {
        ZStack() {
            LinearGradient(gradient: Gradient(colors: [Color(red: 34/255, green: 40/255, blue: 80/255), Color(red: 10/255, green: 20/255, blue: 50/255)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea()
            
            
            VStack(spacing: isWideScreen ? 30 : 24) {
                // Title
                Text("Drawing Steps")
                    .font(.system(size: isWideScreen ? 44 : 36, weight: .heavy))
                    .foregroundColor(Color("PYellow"))
                    .padding(.top, isWideScreen ? 20 : 10)
                
                // Grid
                LazyVGrid(columns: gridColumns, spacing: isWideScreen ? 40 : 30) {
                    ForEach(drawingSteps) { step in
                        VStack(spacing: 10) {
                            Image(step.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: isWideScreen ? 180 : 150, height: isWideScreen ? 180 : 150)
                            
                            Text(step.title)
                                .font(.system(size: isWideScreen ? 18 : 16, weight: .regular))
                                .foregroundColor(.pCream)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        .padding(.horizontal, isWideScreen ? 12 : 8)
                    }
                }
                .padding(.horizontal, isWideScreen ? 24 : 16)
                .padding(.top, isWideScreen ? 25 : 18)
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    router.navigate(to: .dotview(asset: asset))
                }) {
                    Text("Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.pBlue)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.pYellow)
                        .cornerRadius(15)
                }
                .padding(.horizontal, isWideScreen ? 30 : 20)
                .padding(.bottom, isWideScreen ? 40 : 30)
                .accessibilityLabel("1. Continue")
                .accessibilityIdentifier("DrawingStepsContinueButton")
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
            }
        }
        .navigationBarTitleDisplayMode(.automatic) 
    }
}
