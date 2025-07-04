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
    
    @Published var isSessionActive = false
    private var arView: FacePaintingARView?
    
    private init() {}
    
    func getOrCreateARView() -> FacePaintingARView {
        if let existingView = arView {
            return existingView
        }
        
        let newView = FacePaintingARView(frame: .zero)
        newView.backgroundColor = UIColor.clear
        newView.automaticallyConfigureSession = false
        arView = newView
        
        return newView
    }
    
    func setAssetVisible(_ visible: Bool) {
        arView?.isAssetVisible = visible
    }
    
    func startSession() {
        guard let arView = arView else { return }
        
        if !isSessionActive {
            arView.setupSession()
            DispatchQueue.main.async {
                self.isSessionActive = true
            }
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
        DispatchQueue.main.async {
            self.isSessionActive = false
        }
    }
    
    func resumeSession() {
        guard let arView = arView else { return }
        
        if !isSessionActive {
            arView.session.run(arView.session.configuration ?? ARFaceTrackingConfiguration())
            DispatchQueue.main.async {
                self.isSessionActive = true
            }
        }
    }
    
    func stopSession() {
        arView?.stopSession()
        arView = nil
        DispatchQueue.main.async {
            self.isSessionActive = false
        }
    }
    
    func resetSession() {
        stopSession()
        arView = nil
    }
}
