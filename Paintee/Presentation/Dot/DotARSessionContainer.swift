//
//  DotARSessionContainer.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 04/07/25.
//

import SwiftUI
import RealityKit
import ARKit

struct DotARSessionContainer: UIViewRepresentable {
    @ObservedObject var viewModel: DotViewModel
    @ObservedObject private var sessionManager = ARFaceSessionManager.shared
    let showPreviewImage: Bool
    
    func makeUIView(context: Context) -> FacePaintingARView {
        let arView = sessionManager.getOrCreateARView()
        
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: FacePaintingARView, context: Context) {
        sessionManager.setAssetVisible(showPreviewImage)
        DispatchQueue.main.async {
            if !sessionManager.isSessionActive {
                sessionManager.startSession()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }
    
    static func dismantleUIView(_ uiView: FacePaintingARView, coordinator: Coordinator) {
        // Jangan stop session di sini, biarkan tetap running
        print("ARView dismantled, session tetap aktif")
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        let viewModel: DotViewModel
        private var lastProcessTime = Date()
        
        init(viewModel: DotViewModel) {
            self.viewModel = viewModel
        }
                
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            let now = Date()
            if now.timeIntervalSince(lastProcessTime) > 0.3 {
                lastProcessTime = now
                viewModel.analyzeFrame(frame)
            }
        }
    }
}
