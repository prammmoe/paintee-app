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

class PreviewARView: ARView {
    
    var subscription: Cancellable?
    var faceEntity: HasModel? = nil
    var sparklyNormalMap: TextureResource!
    
    var asset: FacePaintingAsset?
    var assetType: FacePaintingAssetType?
    
    // Tambahan: kontrol visibilitas desain
    var isDesignVisible: Bool = true {
        didSet {
            updateFaceTextureFromAsset()
        }
    }
    
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
    
    // Setup with optional ViewModel
    func setup(asset: FacePaintingAsset, assetType: FacePaintingAssetType) {
        self.asset = asset
        self.assetType = assetType
        
        do {
            sparklyNormalMap = try TextureResource.load(named: "sparkly")
        } catch {
            print("Warning: Could not load sparkly texture: \(error)")
        }
        
        // Configure AR session
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        subscription = scene.subscribe(to: SceneEvents.Update.self, onUpdate)
        
        setupFaceAnchor()
    }
    
    private func setupFaceAnchor() {
        faceAnchor = AnchorEntity(.face)
        scene.addAnchor(faceAnchor!)
    }
    
    private func updateFaceTextureFromAsset() {
        guard let asset = asset else { return }
        guard let faceEntity = self.faceEntity else { return }
        
        if isDesignVisible {
            let assetName: String
            switch assetType {
            case .preview:
                assetName = asset.previewImage
            case .dot:
                assetName = asset.dotPreviewImage
            case .outline:
                assetName = asset.outlinePreviewImage
            default:
                assetName = "halalmy"
            }

            if let uiImage = UIImage(named: assetName),
               let cgImage = uiImage.cgImage,
               let flippedImage = flippedVertically(cgImage) {
                updateFaceEntityTextureUsing(cgImage: flippedImage)
            } else {
                print("Warning: Couldn't load face texture asset")
            }
        } else {
            // Hilangkan material desain dari wajah (buat transparan)
            var faceMaterial = PhysicallyBasedMaterial()
            faceMaterial.baseColor = .init(tint: .clear)
            faceMaterial.blending = .transparent(opacity: .init(scale: 0.0))
            faceEntity.model?.materials = [faceMaterial]
        }
    }
    
    private func flippedVertically(_ cgImage: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: cgImage).oriented(.downMirrored)
        let context = CIContext()
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    private func updateFaceEntityTextureUsing(cgImage: CGImage) {
        guard let faceEntity = self.faceEntity,
              let faceTexture = try? TextureResource(image: cgImage,
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
    
    func stopSession() {
        session.pause()
        subscription?.cancel()
        faceAnchor?.removeFromParent()
        faceAnchor = nil
        faceEntity = nil
    }

    deinit {
        subscription?.cancel()
        session.pause()
    }
  
    // Tambahan: fungsi untuk mengatur visibilitas desain
    func setDesignVisible(_ visible: Bool) {
        isDesignVisible = visible
    }
    
    func setPreviewVisibility(show: Bool) {
        setDesignVisible(show)
    }
}


