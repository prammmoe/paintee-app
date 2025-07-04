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
    
    func makeUIView(context: Context) -> FacePaintingARView {
        return sessionManager.getOrCreateARView()
    }
    
    func updateUIView(_ uiView: FacePaintingARView, context: Context) {
        // Pastikan session berjalan ketika view diupdate
        DispatchQueue.main.async {
            if !sessionManager.isSessionActive {
                sessionManager.startSession()
            }
        }
    }
    
    static func dismantleUIView(_ uiView: FacePaintingARView, coordinator: ()) {
        // Jangan stop session di sini, biarkan tetap running
        print("ARView dismantled, session tetap aktif")
    }
}
