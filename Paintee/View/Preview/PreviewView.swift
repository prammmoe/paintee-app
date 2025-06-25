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
    @State private var showPreviewImage = true
    @EnvironmentObject private var router: Router
    
    let asset: FacePaintingAsset
    var body: some View {
        ZStack {
            // AR View with toggle-able preview overlay
            PreviewARViewContainer(asset: asset, showPreviewImage: showPreviewImage)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.navigate(to: .drawingsteptutorialview(asset: asset))
                    } label: {
                        Text("Continue with this design")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("dark-blue"))
                            .cornerRadius(15)
                    }
                    .disabled(showTutorial)
                    .opacity(showTutorial ? 0.5 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Design Preview")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showPreviewImage.toggle()
                }) {
                    Image(systemName: "sparkles")
                        .font(.headline)
                        .foregroundColor(showPreviewImage ? Color.yellow : .white)
                        .padding(10)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
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
                
                Text("You can continue or try different design.\nThe colors shown are just inspiration, feel free to get creative!")
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
                    .cornerRadius(15)
                
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
    let showPreviewImage: Bool

    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(asset: asset, assetType: .preview)
        arView.setDesignVisible(showPreviewImage)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let arVC = uiView as? ARViewController {
            arVC.setDesignVisible(showPreviewImage)
        }
    }
}
