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
    let previewImage: String

    var body: some View {
        ZStack {
            DotARViewContainer(viewModel: viewModel, previewImage: previewImage)
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
                    
                    // Capture Button
                    Button(action: {
                        viewModel.captureARPhoto()
                    }) {
                        Text("Continue to drawing step")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canCapture ? Color.green : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(!viewModel.canCapture)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
        }
        .navigationTitle("Position Your Face")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Photo Captured", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Face with stars captured successfully!")
        }
        .alert("Error", isPresented: $viewModel.showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
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

struct DotARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: DotViewModel
    let previewImage: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(previewImage: previewImage) // With VM
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
        let viewModel: DotViewModel
        
        init(viewModel: DotViewModel) {
            self.viewModel = viewModel
        }
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            viewModel.analyzeFrame(frame)
        }
    }
}

