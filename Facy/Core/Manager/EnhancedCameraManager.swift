//
//  EnhancedCameraManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

/**
 MARK: Unused
 */

import SwiftUI
import CoreMotion
import Vision
import AVFoundation

// MARK: - Enhanced Camera Manager
class EnhancedCameraManager: NSObject, ObservableObject {
    @Published var warningMessage = "Position your face for setup before you start outlining"
    @Published var canCapture = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = "" // TODO: Define default error message
    
    // Detection states
    @Published var faceDetected = false
    @Published var faceMoving = false
    @Published var deviceMoving = false
    @Published var lightingGood = true
    
    // AVFoundation setup
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
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: backCamera) else {
            errorMessage = "Unable to access camera"
            showErrorAlert = true
            return
        }
        
        photoOutput = AVCapturePhotoOutput()
        
        captureSession?.addInput(input)
        if let photoOutput = photoOutput {
            captureSession?.addOutput(photoOutput)
        }
        
        // Add video output for face detection
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession?.addOutput(videoOutput)
        
        // Start session in background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession?.startRunning()
        }
    }

    func setupCamera(in view: UIView) {
        guard let captureSession = captureSession else { return }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.frame = view.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer!)
    }
    
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
                self.deviceMoving = totalDelta > 0.3 // Threshold for device movement
            }
            
            self.lastAccelerometerData = data
            self.updateCaptureStatus()
        }
    }
    
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
    
    func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func stopCamera() {
        captureSession?.stopRunning()
        motionManager.stopAccelerometerUpdates()
    }
    
    deinit {
        stopCamera()
    }
}

// MARK: - Camera Manager Extensions
extension EnhancedCameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation], !results.isEmpty {
                    self.faceDetected = true
                    
                    // Check face movement
                    if let firstFace = results.first {
                        let currentPosition = CGPoint(x: firstFace.boundingBox.midX, y: firstFace.boundingBox.midY)
                        self.facePositionHistory.append(currentPosition)
                        
                        // Keep only recent positions
                        if self.facePositionHistory.count > 10 {
                            self.facePositionHistory.removeFirst()
                        }
                        
                        // Check if face is moving
                        if self.facePositionHistory.count > 5 {
                            let recent = Array(self.facePositionHistory.suffix(5))
                            let avgX = recent.map { $0.x }.reduce(0, +) / Double(recent.count)
                            let avgY = recent.map { $0.y }.reduce(0, +) / Double(recent.count)
                            
                            let variance = recent.map { pow($0.x - avgX, 2) + pow($0.y - avgY, 2) }.reduce(0, +) / Double(recent.count)
                            self.faceMoving = variance > 0.001 // Movement threshold
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

extension EnhancedCameraManager: AVCapturePhotoCaptureDelegate {
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
