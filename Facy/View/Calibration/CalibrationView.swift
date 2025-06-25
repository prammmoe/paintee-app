//
//  FaceDetectionView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 14/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct CalibrationView: View {
    @StateObject private var viewModel = CalibrationViewModel()
    let asset: FacePaintingAsset
    
    @EnvironmentObject private var router: Router
    @State private var navigateToStepOne = false

    var body: some View {
        ZStack {
            CalibrationARViewContainer(viewModel: viewModel, asset: asset)
                .ignoresSafeArea(.all)

            VStack {
                VStack {
                    Text(viewModel.warningMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 60)

                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 20) {
                        StatusIndicator(
                            title: "Face",
                            isGood: viewModel.faceDetected && !viewModel.faceMoving,
                            icon: "face.smiling"
                        )

                        StatusIndicator(
                            title: "Device",
                            isGood: !viewModel.deviceMoving,
                            icon: "iphone"
                        )

                        StatusIndicator(
                            title: "Light",
                            isGood: viewModel.lightingGood,
                            icon: "sun.max"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 12) {
                        
                        Button {
                            router.navigate(to: .dotview(asset: asset))
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
        }

        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Position Your Face")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct StatusIndicator: View {
    let title: String
    let isGood: Bool
    let icon: String

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isGood ? .green : .red)

            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.black.opacity(0.6))
        .cornerRadius(8)
    }
}

struct CalibrationARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: CalibrationViewModel
    let asset: FacePaintingAsset
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(asset: asset, assetType: .preview)
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        if let customARView = uiView as? ARViewController {
            customARView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        let viewModel: CalibrationViewModel
        
        init(viewModel: CalibrationViewModel) {
            self.viewModel = viewModel
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            viewModel.analyzeFrame(frame)
        }
    }
}

