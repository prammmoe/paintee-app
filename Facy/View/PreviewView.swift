//
//  FacePaintingViewContainer.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct PreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTutorial = true
//    @State private var isARActive = true  // <--- Tambahkan ini
    @StateObject private var coordinator = ARFacePaintCoordinator() // Use the new manager

    var body: some View {
        ZStack {
            // AR View Container sebagai background
            ARFacePaintManager(coordinator: coordinator) // <--- Berikan binding state
                .edgesIgnoringSafeArea(.all)
                .blur(radius: showTutorial ? 10 : 0)
                .animation(.easeInOut(duration: 0.3), value: showTutorial)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    NavigationLink(destination: DotView()) {
                        Text("Continue with this design")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(showTutorial)
                    .opacity(showTutorial ? 0.5 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .navigationTitle("Star Design Preview")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
                .fontWeight(.semibold)
            }
        }
        .onDisappear {
//            isARActive = false // <--- Ini akan trigger ARViewContainer untuk stop session
        }
        .sheet(isPresented: $showTutorial) {
            TutorialSheetView()
        }
    }
}

// Tutorial Sheet View
struct TutorialSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Handle indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.secondary)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Preview your selected face painting guide")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("You can continue or try\ndifferent design")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Okay")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
        .background(Color(.systemBackground))
        .presentationDetents([.fraction(0.50)])
        .presentationDragIndicator(.hidden)
    }
}
