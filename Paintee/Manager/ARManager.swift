//
//  ARManager.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 01/07/25.
//

import ARKit
import RealityKit
import Combine

class ARManager: ObservableObject {
    @Published var message: String?
    @Published var isDesignVisible: Bool = true {
        didSet {
            // For each this value changes, the function will be called to update face texture
            updateFaceTextureFromAsset()
        }
    }
    
    // Only instance that will be used on the entire application
    let arView = ARView(frame: .zero)
    
    private var subscription: Cancellable?
    private var faceEntity: HasModel?
    private var sparklyNormalMap: TextureResource?
    
    private var currentAsset: FacePaintingAsset?
    private var currentAssetType: FacePaintingAssetType?
    
    private static let sceneUnderstandingQuery = EntityQuery(where: .has(SceneUnderstandingComponent.self) && .has(ModelComponent.self))
    
    private var faceTrackingConfig: ARFaceTrackingConfiguration {
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        return configuration
    }
    
    init() {
        setupCoachingOverlay()
        
        do {
            sparklyNormalMap = try TextureResource.load(named: "sparkly")
        } catch {
            print("Cannot load face texture resource: \(error)")
            self.message = "Cannot load face texture resource"
        }
        
        self.subscription = arView.scene.subscribe(to: SceneEvents.Update.self) { [weak self] event in
            self?.onUpdate(event)
        }
    }
    
    deinit {
        subscription?.cancel()
    }
    
    func startSession() {
        guard ARFaceTrackingConfiguration.isSupported else {
            self.message = "Face tracking is not supported on this device."
            return
        }
        
        arView.session.run(faceTrackingConfig, options: [.resetTracking, .removeExistingAnchors])
        print("AR Session Started")
    }
    
    func pauseSession() {
        arView.session.pause()
        print("AR Session Paused")
    }
    
    func clearAllEntities() {
        arView.scene.anchors.removeAll()
        faceEntity = nil
    }
    
    func setupForPreview(asset: FacePaintingAsset) {
        clearAllEntities()
        self.currentAsset = asset
        self.currentAssetType = .preview
        updateFaceTextureFromAsset()
        print("Setup for Preview with asset: \(asset.previewImage)")
    }
    
    func setupForDotView(asset: FacePaintingAsset) {
        clearAllEntities()
        self.currentAsset = asset
        self.currentAssetType = .dot
        updateFaceTextureFromAsset()
        print("Setup for DotView with asset: \(asset.dotPreviewImage)")
    }
    
    func setupForConnectDotView(asset: FacePaintingAsset) {
        clearAllEntities()
        self.currentAsset = asset
        self.currentAssetType = .outline
        updateFaceTextureFromAsset()
        print("Setup for ConnectDotView with asset: \(asset.outlinePreviewImage)")
    }
    
    func setupForDrawingView(asset: FacePaintingAsset) {
        clearAllEntities()
        self.currentAsset = asset
        self.currentAssetType = .outline
        updateFaceTextureFromAsset()
        print("Setup for DrawingView with asset: \(asset.outlinePreviewImage)")
    }
    
    private func onUpdate(_ event: Event) {
        // Jika entitas wajah belum ditemukan, coba cari.
        if faceEntity == nil {
            faceEntity = findFaceEntity(scene: arView.scene)
            // Jika berhasil ditemukan, langsung update teksturnya.
            if faceEntity != nil {
                updateFaceTextureFromAsset()
            }
        }
    }
    
    private func findFaceEntity(scene: RealityKit.Scene) -> HasModel? {
        let faceEntity = scene.performQuery(Self.sceneUnderstandingQuery).first {
            $0.components[SceneUnderstandingComponent.self]?.entityType == .face
        }
        return faceEntity as? HasModel
    }
    
    private func updateFaceTextureFromAsset() {
        guard let asset = currentAsset, let assetType = currentAssetType else { return }
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
            }
            
            if let uiImage = UIImage(named: assetName),
               let cgImage = uiImage.cgImage,
               let flippedImage = flippedVertically(cgImage) {
                updateFaceEntityTextureUsing(cgImage: flippedImage)
            } else {
                print("Peringatan: Tidak dapat memuat aset tekstur wajah '\(assetName)'")
            }
        } else {
            // Hilangkan material desain dari wajah (buat transparan)
            var transparentMaterial = UnlitMaterial(color: .clear)
            transparentMaterial.blending = .transparent(opacity: .init(scale: 0.0))
            faceEntity.model?.materials = [transparentMaterial]
        }
    }
    
    private func updateFaceEntityTextureUsing(cgImage: CGImage) {
        guard let faceEntity = self.faceEntity else { return }
        
        guard let faceTexture = try? TextureResource.generate(from: cgImage, withName: nil, options: .init(semantic: .color)) else {
            print("Gagal membuat tekstur dari CGImage.")
            return
        }
        
        var faceMaterial = PhysicallyBasedMaterial()
        faceMaterial.baseColor.texture = MaterialParameters.Texture(faceTexture)
        faceMaterial.roughness = 0.1
        faceMaterial.metallic = 0.1
        faceMaterial.blending = .transparent(opacity: .init(scale: 1.0))
        
        if let sparklyMap = sparklyNormalMap {
            faceMaterial.normal.texture = MaterialParameters.Texture(sparklyMap)
        }
        
        faceEntity.model?.materials = [faceMaterial]
    }
    
    private func flippedVertically(_ cgImage: CGImage) -> CGImage? {
        let ciImage = CIImage(cgImage: cgImage).oriented(.downMirrored)
        let context = CIContext()
        return context.createCGImage(ciImage, from: ciImage.extent)
    }
    
    private func setupCoachingOverlay() {
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.goal = .tracking
        arView.addSubview(coachingOverlay)
    }
}
