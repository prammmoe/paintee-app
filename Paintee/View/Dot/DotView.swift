//
//  FaceDetectionView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 14/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct DotView: View {
    @StateObject private var viewModel = DotViewModel()
    let asset: FacePaintingAsset
    
    @EnvironmentObject private var router: Router
    @State private var navigateToStepOne = false
    @State private var showPreviewImage = true
    
    var body: some View {
        ZStack {
            CalibrationARViewContainer(viewModel: viewModel, asset: asset, showPreviewImage: showPreviewImage)
                .ignoresSafeArea(.all)
    
            VStack {
                Text(viewModel.warningMessage)
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
                        router.navigate(to: .connectdotview(asset: asset))
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("dark-blue"))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Step 1 of 3")
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

struct CalibrationARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: DotViewModel
    let asset: FacePaintingAsset
    let showPreviewImage: Bool
    
    func makeUIView(context: Context) -> ARView {
        let arView = DotARView(frame: .zero)
        arView.setup(asset: asset, assetType: .dot)
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let arVC = uiView as? DotARView {
            arVC.setDesignVisible(showPreviewImage)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        if let customARView = uiView as? DotARView {
            customARView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        let viewModel: DotViewModel
        
        init(viewModel: DotViewModel) {
            self.viewModel = viewModel
        }
        
        private var lastProcessTime = Date()
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            let now = Date()
            if now.timeIntervalSince(lastProcessTime) > 0.3 {
                lastProcessTime = now
                viewModel.analyzeFrame(frame)
            }
        }
    }
}

