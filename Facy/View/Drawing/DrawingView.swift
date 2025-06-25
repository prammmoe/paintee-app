//
//  DrawingView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct DrawingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: Router
    let asset: FacePaintingAsset

    var body: some View {
        ZStack {
            DrawingARViewContainer(asset: asset)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Step 3 of 3")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .padding()
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.reset()
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .navigationTitle("Star Design Preview")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .onDisappear {
            // TODO: State handling when view dismantled
        }
    }
}

struct DrawingARViewContainer: UIViewRepresentable {
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
