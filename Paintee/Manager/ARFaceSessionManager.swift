//
//  ARFaceSessionManager.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 03/07/25.
//
import RealityKit
import ARKit

class ARFaceSessionManager: ObservableObject {
    static let shared = ARFaceSessionManager()
    
    @Published var arView: FacePaintingARView?
    @Published var isSessionActive = false
    
    private init() {}
    
    func createARView() -> FacePaintingARView {
        if let existingView = arView {
            return existingView
        }
        
        let newView = FacePaintingARView(frame: .zero)
        arView = newView
        return newView
    }
    
    func startSession() {
        guard let arView = arView else { return }
        
        if !isSessionActive {
            arView.setupSession()
            isSessionActive = true
        }
    }
    
    func applyAsset(_ asset: FacePaintingAsset, type: FacePaintingAssetType) {
        guard let arView = arView else { return }
        
        arView.asset = asset
        arView.assetType = type
        arView.updateFaceTextureFromAsset()
    }
    
    func clearAsset() {
        arView?.clearFaceTexture()
    }
    
    func pauseSession() {
        arView?.session.pause()
        isSessionActive = false
    }
    
    func resumeSession() {
        guard let arView = arView else { return }
        
        if !isSessionActive {
            arView.session.run(arView.session.configuration ?? ARFaceTrackingConfiguration())
            isSessionActive = true
        }
    }
    
    func stopSession() {
        arView?.stopSession()
        isSessionActive = false
    }
    
    func resetSession() {
        stopSession()
        arView = nil
    }
}
