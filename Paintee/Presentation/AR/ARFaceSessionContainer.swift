//
//  ARFaceSessionContainer.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 03/07/25.
//

import SwiftUI
import RealityKit

struct ARFaceSessionContainer: UIViewRepresentable {
    @ObservedObject private var sessionManager = ARFaceSessionManager.shared
    let showPreviewImage: Bool
    
    func makeUIView(context: Context) -> FacePaintingARView {
        return sessionManager.getOrCreateARView()
    }
    
    func updateUIView(_ uiView: FacePaintingARView, context: Context) {
        sessionManager.setAssetVisible(showPreviewImage)

        DispatchQueue.main.async {
            if !sessionManager.isSessionActive {
                sessionManager.startSession()
            }
        }
    }
    
    static func dismantleUIView(_ uiView: FacePaintingARView, coordinator: ()) {
        print("ARView dismantled, session tetap aktif")
    }
}
