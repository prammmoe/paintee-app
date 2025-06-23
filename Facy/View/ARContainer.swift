//
//  ARFaceView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 22/06/25.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

// MARK: - Enhanced FacePaintingView with ViewModel Integration
class ARContainer: ARView {
    
    var subscription: Cancellable?
    var faceEntity: HasModel? = nil
    var sparklyNormalMap: TextureResource!
    
    // Connection to ViewModel
    weak var viewModel: DotViewModel?
    
    // Star entities for face painting
    private var leftStarEntity: ModelEntity?
    private var rightStarEntity: ModelEntity?
    private var faceAnchor: AnchorEntity?
    
    static let sceneUnderstandingQuery = EntityQuery(where: .has(SceneUnderstandingComponent.self) && .has(ModelComponent.self))
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
    }
    
    override var canBecomeFirstResponder: Bool { true }
    
    func setup(with viewModel: DotViewModel) {
        self.viewModel = viewModel
        
        // Load sparkly texture
        do {
            sparklyNormalMap = try TextureResource.load(named: "sparkly")
        } catch {
            print("Warning: Could not load sparkly texture: \(error)")
            // Create a default normal map texture if needed
        }
        
        // Configure AR session
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.delegate = self
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        // Subscribe to scene updates
        subscription = scene.subscribe(to: SceneEvents.Update.self, onUpdate)
        
        // Create face anchor
        setupFaceAnchor()
    }
    
    private func setupFaceAnchor() {
        faceAnchor = AnchorEntity(.face)
        scene.addAnchor(faceAnchor!)
        
    }
    
    private func updateFaceTextureFromAsset() {
        if let uiImage = UIImage(named: "halalmy"),
           let cgImage = uiImage.cgImage,
           let flippedImage = flippedVertically(cgImage) {
            updateFaceEntityTextureUsing(cgImage: flippedImage)
        } else {
            print("Warning: Couldn't load face texture asset")
        }
    }
    
    private func flippedVertically(_ cgImage: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: cgImage).oriented(.downMirrored)
        let context = CIContext()
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    private func updateFaceEntityTextureUsing(cgImage: CGImage) {
        guard let faceEntity = self.faceEntity,
              let faceTexture = try? TextureResource.generate(from: cgImage,
                                                             options: .init(semantic: .color))
        else { return }
        
        var faceMaterial = PhysicallyBasedMaterial()
        faceMaterial.baseColor.texture = PhysicallyBasedMaterial.Texture(faceTexture)
        faceMaterial.roughness = 0.1
        faceMaterial.metallic = 0.1
        faceMaterial.blending = .transparent(opacity: .init(scale: 1.0))
        faceMaterial.opacityThreshold = 0.5
        
        if let sparklyMap = sparklyNormalMap {
            faceMaterial.normal.texture = PhysicallyBasedMaterial.Texture(sparklyMap)
        }
        
        faceEntity.model!.materials = [faceMaterial]
    }
    
    private func findFaceEntity(scene: RealityKit.Scene) -> HasModel? {
        let faceEntity = scene.performQuery(Self.sceneUnderstandingQuery).first {
            $0.components[SceneUnderstandingComponent.self]?.entityType == .face
        }
        return faceEntity as? HasModel
    }
    
    private func onUpdate(_ event: Event) {
        if faceEntity == nil {
            faceEntity = findFaceEntity(scene: scene)
            if faceEntity != nil {
                updateFaceTextureFromAsset()
            }
        }
        
    }

    deinit {
        subscription?.cancel()
        session.pause()
    }
}

// MARK: - ARSessionDelegate Implementation
extension ARContainer: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Call ViewModel methods for face and lighting detection
        viewModel?.detectLighting(frame: frame)
        viewModel?.detectFace(frame: frame)
    }
}
