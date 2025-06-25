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
    @EnvironmentObject private var router: Router
    
    let asset: FacePaintingAsset

    var body: some View {
        ZStack {
            PreviewARViewContainer(asset: asset)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.navigate(to: .dotview(asset: asset))
                    } label: {
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
        .onDisappear {
//            isARActive = false // <--- Ini akan trigger ARViewContainer untuk stop session
        }
        .sheet(isPresented: $showTutorial) {
            TutorialSheetView()
        }
    }
}

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

struct PreviewARViewContainer: UIViewRepresentable {
    let asset: FacePaintingAsset
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(asset: asset, assetType: .preview) // Without VM
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        if let customView = uiView as? ARViewController {
            customView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
}

