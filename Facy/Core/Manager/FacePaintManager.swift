//
//  FacePaintManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 19/06/25.
//

import RealityKit
import ARKit
import Combine
import simd
import UIKit
import CoreImage

/// A single responsibility object that owns:
///  1. your ARSession configuration
///  2. your scene-update subscription
///  3. your face model lookup + texture updates
final class FacePaintManager {
    
    /// Call this once, right after your ARView is created
    func start(on arView: ARView) {
        self.arView = arView
        loadResources()
        runFaceTracking()
        subscribeToUpdates()
    }
    
    // MARK: - Private
    
    private weak var arView: ARView?
    private var subscription: Cancellable?
    private var faceEntity: HasModel?
    private var sparklyNormalMap: TextureResource!
    
    /// We only need to load this once
    /// Sparkly texture
    private func loadResources() {
        do {
            sparklyNormalMap = try TextureResource.load(named: "sparkly")
        } catch {
            assertionFailure("Failed to load sparkle map: \(error)")
        }
    }
    
    private func runFaceTracking() {
        guard let session = arView?.session else { return }
        let config = ARFaceTrackingConfiguration()
        session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
        // attach a “dummy” world anchor so our scene.root won’t be empty
        let worldAnchor = AnchorEntity(.world(transform: .init(diagonal: [1, 1, 1, 1])))
        arView?.scene.anchors.append(worldAnchor)
    }
    
    private func subscribeToUpdates() {
        guard let scene = arView?.scene else { return }
        subscription = scene.subscribe(to: SceneEvents.Update.self, { [weak self] in
            self?.handleUpdate($0)
        })
    }
    
    private func handleUpdate(_ event: SceneEvents.Update) {
        // first time only: grab the face model, apply initial texture
        if faceEntity == nil {
            faceEntity = findFaceEntity(in: event.scene)
            faceEntity.flatMap { _ in updateFaceTextureFromAsset() }
        }
        // you could add per-frame logic here if needed…
    }
    
    private static let faceQuery = EntityQuery(where: .has(SceneUnderstandingComponent.self) && .has(ModelComponent.self))
    
    private func findFaceEntity(in scene: RealityKit.Scene) -> HasModel? {
        return scene
            .performQuery(Self.faceQuery)
            .first { anchor in
                anchor.components[SceneUnderstandingComponent.self]?.entityType == .face
            } as? HasModel
    }
    
    private func updateFaceTextureFromAsset() {
        guard
            let uiImage    = UIImage(named: "star"),
            let cgImage    = uiImage.cgImage,
            let flipped    = Self.flippedVertically(cgImage),
            let faceEntity = faceEntity
        else { return }
        
        applyTexture(flipped, to: faceEntity)
    }
    
    private static func flippedVertically(_ cg: CGImage) -> CGImage? {
        let ci = CIImage(cgImage: cg).oriented(.downMirrored)
        return CIContext().createCGImage(ci, from: ci.extent)
    }
    
    private func applyTexture(_ cgImage: CGImage, to entity: HasModel) {
        guard
            let faceTex = try? TextureResource(image: cgImage, options: .init(semantic: .color))
        else { return }
        
        var mat = PhysicallyBasedMaterial()
        mat.baseColor.texture   = .init(faceTex)
        mat.roughness            = 0.1
        mat.metallic             = 0.1
        mat.blending             = .transparent(opacity: .init(scale: 1.0))
        mat.opacityThreshold     = 0.5
        mat.normal.texture       = .init(sparklyNormalMap)
        
        entity.model?.materials = [mat]
    }
}




