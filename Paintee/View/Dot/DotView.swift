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
    @Environment(\.dismiss) private var dismiss
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
                        router.navigate(to: .connectdotview(asset: asset))
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.pCream)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canStartDotting ? Color.pBlue : .pBlue.opacity(0.5))
                            .cornerRadius(15)
                    }
                    .disabled(!viewModel.canStartDotting)
                    .animation(.easeInOut(duration: 0.2), value: viewModel.canStartDotting)
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
                Text("Step 1 of 3")
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

