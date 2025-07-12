//
//  FacePaintingARView.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 03/07/25.
//

import SwiftUI
import ARKit
import RealityKit
import Combine

class FacePaintingARView: ARView {
    
    var subscription: Cancellable?
    var faceEntity: HasModel? = nil
    var sparklyNormalMap: TextureResource!
    
    var asset: FacePaintingAsset?
    var assetType: FacePaintingAssetType?
    
    var isAssetVisible: Bool = true {
        didSet {
            updateFaceTextureFromAsset()
        }
    }
    
    private var faceAnchor: AnchorEntity?
    
    static let sceneUnderstandingQuery = EntityQuery(where: .has(SceneUnderstandingComponent.self) && .has(ModelComponent.self))
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        print("PreviewARView started")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isMultipleTouchEnabled = true
        print("PreviewARView started")
    }
    
    deinit {
        subscription?.cancel()
        session.pause()
        print("PreviewARView stopped")
    }
    
    override var canBecomeFirstResponder: Bool { true }
    
    // AR Session setup
    func setupSession() {
        do {
            sparklyNormalMap = try TextureResource.load(named: "sparkly")
        } catch {
            print("Warning: Could not load sparkly texture: \(error)")
        }
        
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        session.run(configuration, options: [
            .resetTracking,
            .removeExistingAnchors,
            .stopTrackedRaycasts,
            .resetSceneReconstruction
        ])
        
        subscription = scene.subscribe(to: SceneEvents.Update.self, onUpdate)

    }
    
    func updateFaceTextureFromAsset() {
        guard let asset = asset else { return }
        
        if isAssetVisible {
            let assetName: String
            switch assetType {
            case .preview:
                assetName = asset.previewImage
            case .dot:
                assetName = asset.dotPreviewImage
            case .outline:
                assetName = asset.outlinePreviewImage
            default:
                assetName = "emptyasset"
            }

            if let uiImage = UIImage(named: assetName),
               let cgImage = uiImage.cgImage,
               let flippedImage = flippedVertically(cgImage) {
                updateFaceEntityTextureUsing(cgImage: flippedImage)
            } else {
                print("Warning: Couldn't load face texture asset")
            }
        } else {
            if let uiImage = UIImage(named: "emptyasset"),
               let cgImage = uiImage.cgImage,
               let flippedImage = flippedVertically(cgImage) {
                updateFaceEntityTextureUsing(cgImage: flippedImage)
            } else {
                print("Warning: Couldn't load face texture asset")
            }
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
        scene.anchors.removeAll()
        removeFromSuperview()
        subscription?.cancel()
        faceAnchor?.removeFromParent()
        faceAnchor = nil
        faceEntity = nil
    }
  
    func setAssetVisible(_ visible: Bool) {
        isAssetVisible = visible
    }
    
    func setPreviewVisibility(show: Bool) {
        setAssetVisible(show)
    }
    
    func clearFaceTexture() {
        guard let faceEntity = self.faceEntity else { return }
        var faceMaterial = PhysicallyBasedMaterial()
        faceMaterial.baseColor = .init(tint: .clear)
        faceMaterial.blending = .transparent(opacity: .init(scale: 0.0))
        faceEntity.model?.materials = [faceMaterial]
    }
}

