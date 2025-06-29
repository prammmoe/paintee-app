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
                            .foregroundColor(.pCream)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.pBlue)
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
            ToolbarItem(placement: .principal) {
                Text("Design Preview")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showPreviewImage.toggle()
                }) {
                    Image(systemName: "sparkles")
                        .font(.subheadline)
                        .foregroundColor(showPreviewImage ? .pYellow : .white)
                        .padding(7)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
        .toolbarBackground(Color.pBlue.opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
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
                .fill(Color.pBlue)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Preview your design")
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
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.pBlue)
                    .cornerRadius(15)
                
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 34)
        }
        .background(Color(.pCream))
        .presentationDetents([.fraction(0.40)])
        .presentationDragIndicator(.hidden)
        .onDisappear {
            print("PreviewView disappeared, session will stop (via dismantleUIView)")
        }
    }
}

struct PreviewARViewContainer: UIViewRepresentable {
    let asset: FacePaintingAsset
    let showPreviewImage: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = PreviewARView(frame: .zero)
        arView.setup(asset: asset, assetType: .preview)
        arView.setDesignVisible(showPreviewImage)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let arVC = uiView as? PreviewARView {
            arVC.setDesignVisible(showPreviewImage)
        }
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        if let customView = uiView as? PreviewARView {
            customView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
}
