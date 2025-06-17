//
//  UnifiedCameraManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 17/06/25.
//

import SwiftUI
import ARKit
import RealityKit
import CoreMotion
import Vision
import AVFoundation

// MARK: - Unified Camera Manager
class UnifiedCameraManager: NSObject, ObservableObject {
    // Published properties for UI updates
    @Published var warningMessage = "Position your face for setup before you start outlining"
    @Published var canCapture = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""
    
    // Detection states
    @Published var faceDetected = false
    @Published var faceMoving = false
    @Published var deviceMoving = false
    @Published var lightingGood = true
    
    // ARKit and AVFoundation setup
    private var arSceneView: ARSCNView?
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput: AVCapturePhotoOutput?
    
    // Motion detection setup
    private let motionManager = CMMotionManager()
    private var lastAccelerometerData: CMAccelerometerData?
    private var facePositionHistory: [CGPoint] = []
    
    // Face detection setup
    private let faceDetectionRequest = VNDetectFaceRectanglesRequest()
    
    override init() {
        super.init()
        setupMotionDetection()
    }
    
    // MARK: - ARKit Setup
    func setupARView(in view: UIView) {
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("ARFaceTracking is not supported on this device.")
        }
        
        let sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        view.addSubview(sceneView)
        arSceneView = sceneView
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    // MARK: - AVFoundation Setup
    func requestPermissionForCamera() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                if granted {
                    self?.setupCamera()
                } else {
                    self?.errorMessage = "Camera permission denied"
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: frontCamera) else {
            errorMessage = "Unable to access camera"
            showErrorAlert = true
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        
        captureSession?.addInput(input)
        if let photoOutput = photoOutput {
            captureSession?.addOutput(photoOutput)
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession?.addOutput(videoOutput)
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }
    
    func setupCameraPreview(in view: UIView) {
        guard let captureSession = captureSession else { return }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
    }
    
    // MARK: - Motion Detection
    private func setupMotionDetection() {
        guard motionManager.isAccelerometerAvailable else { return }
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, error in
            guard let self = self, let data = data else { return }
            
            if let lastData = self.lastAccelerometerData {
                let deltaX = abs(data.acceleration.x - lastData.acceleration.x)
                let deltaY = abs(data.acceleration.y - lastData.acceleration.y)
                let deltaZ = abs(data.acceleration.z - lastData.acceleration.z)
                
                let totalDelta = deltaX + deltaY + deltaZ
                self.deviceMoving = totalDelta > 0.3
            }
            
            self.lastAccelerometerData = data
            self.updateCaptureStatus()
        }
    }
    
    // MARK: - Capture Status
    private func updateCaptureStatus() {
        let allConditionsGood = faceDetected && !faceMoving && !deviceMoving && lightingGood
        
        DispatchQueue.main.async {
            self.canCapture = allConditionsGood
            
            if !self.faceDetected {
                self.warningMessage = "No face detected. Make sure your face is in screen."
            } else if self.faceMoving {
                self.warningMessage = "Keep your face still."
            } else if self.deviceMoving {
                self.warningMessage = "Keep device steady."
            } else if !self.lightingGood {
                self.warningMessage = "Improve lighting conditions."
            } else {
                self.warningMessage = "Perfect! Ready to draw."
            }
        }
    }
    
    // MARK: - Photo Capture
    func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func stopAllSessions() {
        arSceneView?.session.pause()
        captureSession?.stopRunning()
        motionManager.stopAccelerometerUpdates()
    }
    
    deinit {
        stopAllSessions()
    }
}

// MARK: - ARSCNViewDelegate
extension UnifiedCameraManager: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }
        
        let node = SCNNode()
        // Add custom AR content here (e.g., cheek paintings)
        return node
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension UnifiedCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation], !results.isEmpty {
                    self.faceDetected = true
                    
                    if let firstFace = results.first {
                        let currentPosition = CGPoint(x: firstFace.boundingBox.midX, y: firstFace.boundingBox.midY)
                        self.facePositionHistory.append(currentPosition)
                        
                        if self.facePositionHistory.count > 10 {
                            self.facePositionHistory.removeFirst()
                        }
                        
                        if self.facePositionHistory.count > 5 {
                            let recent = Array(self.facePositionHistory.suffix(5))
                            let avgX = recent.map { $0.x }.reduce(0, +) / CGFloat(recent.count)
                            let avgY = recent.map { $0.y }.reduce(0, +) / CGFloat(recent.count)
                            
                            let variance = recent.map { pow($0.x - avgX, 2) + pow($0.y - avgY, 2) }.reduce(0, +) / CGFloat(recent.count)
                            self.faceMoving = variance > 0.001
                        }
                    }
                } else {
                    self.faceDetected = false
                    self.faceMoving = false
                }
                
                self.updateCaptureStatus()
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        try? handler.perform([request])
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension UnifiedCameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to capture photo"
                self.showErrorAlert = true
            }
        } else {
            DispatchQueue.main.async {
                self.showSuccessAlert = true
            }
        }
    }
}