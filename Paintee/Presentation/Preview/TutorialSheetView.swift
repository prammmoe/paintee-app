//
//  TutorialSheetView.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 12/07/25.
//


import SwiftUI
import ARKit
import RealityKit

struct TutorialSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.pBlue)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Preview your design!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pBlue)
                
                Text("You can use this design or pick another.\nThe colors shown are just examples,\nfeel free to get creative!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pBlue)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                dismiss()
            }) {
                Text("Okay")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.pBlue)
                    .cornerRadius(15)
                
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 34)
            .accessibilityLabel("1. Continue")
            .accessibilityIdentifier("ConnectContinueButton")
        }
        .background(Color(.pCream))
        .presentationDetents([.fraction(0.40)])
        .presentationDragIndicator(.hidden)
    }
}