//
//  StepThree.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct DrawingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTutorial = true
    @State private var showPreviewImage = true
    @EnvironmentObject private var router: Router
    let asset: FacePaintingAsset
    
    var body: some View {
        ZStack {
            DrawingARViewContainer(asset: asset, showPreviewImage: showPreviewImage)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Time to paint it all in!")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.orange.opacity(0.5))
                    .cornerRadius(12)
                    .padding(.top, 100)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.navigate(to: .camerasnapview)
                        print("Otw navigation to CameraSnapView")
                    } label: {
                        Text("Finish")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("dark-yellow"))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Step 3 of 3")
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
    }
}

struct DrawingARViewContainer: UIViewRepresentable {
    let asset: FacePaintingAsset
    let showPreviewImage: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = DrawingARView(frame: .zero)
        arView.setup(asset: asset, assetType: .outline)
        arView.setDesignVisible(showPreviewImage)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let arVC = uiView as? DrawingARView {
            arVC.setDesignVisible(showPreviewImage)
        }
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        if let customView = uiView as? DrawingARView {
            customView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
}



