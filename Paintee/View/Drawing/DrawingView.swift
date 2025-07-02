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
                    .background(.pYellow.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.top, 125)
                
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
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.pBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.pTurq)
                            .cornerRadius(15)
                    }
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
                Text("Step 3 of 3")
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
                        .foregroundColor(showPreviewImage ? Color.yellow : .white)
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
        .onDisappear {
            print("DrawingView disappeared, session will stop (via dismantleUIView)")
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
}
