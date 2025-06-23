//
//  DotViewModel.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 22/06/25.
//

import SwiftUI
import Vision
import ARKit
import CoreMotion

class DotViewModel: ObservableObject {
    @Published var warningMessage = "Position your face for setup before you start outlining"
    @Published var canCapture = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    @Published var faceDetected = false
    @Published var faceMoving = false
    @Published var deviceMoving = false
    @Published var lightingGood = true
    
    private var lastDetectionTime = Date()

    private var facePositionHistory: [CGPoint] = []
    private let motionManager = CMMotionManager()
    private var lastAccelerometerData: CMAccelerometerData?

    init() {
        setupMotionDetection()
    }

    func setupMotionDetection() {
        guard motionManager.isAccelerometerAvailable else { return }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let data = data else { return }

            if let last = self.lastAccelerometerData {
                let deltaX = abs(data.acceleration.x - last.acceleration.x)
                let deltaY = abs(data.acceleration.y - last.acceleration.y)
                let deltaZ = abs(data.acceleration.z - last.acceleration.z)

                let total = deltaX + deltaY + deltaZ
                self.deviceMoving = total > 0.3
            }

            self.lastAccelerometerData = data
            self.updateCaptureStatus()
        }
    }

    func detectLighting(frame: ARFrame) {
        let lightEstimate = frame.lightEstimate
        lightingGood = lightEstimate?.ambientIntensity ?? 1000 > 200
    }

    func detectFace(frame: ARFrame) {
        // Only perform the request every few frames to prevent lag
        let currentTime = Date()
        guard currentTime.timeIntervalSince(lastDetectionTime) > 0.1 else { return }
        lastDetectionTime = currentTime

        let request = VNDetectFaceRectanglesRequest { [weak self] request, _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if let results = request.results as? [VNFaceObservation], let face = results.first {
                    self.faceDetected = true
                    let current = CGPoint(x: face.boundingBox.midX, y: face.boundingBox.midY)
                    self.facePositionHistory.append(current)

                    if self.facePositionHistory.count > 10 {
                        self.facePositionHistory.removeFirst()
                    }

                    if self.facePositionHistory.count > 5 {
                        let recent = Array(self.facePositionHistory.suffix(5))
                        let avgX = recent.map { $0.x }.reduce(0, +) / Double(recent.count)
                        let avgY = recent.map { $0.y }.reduce(0, +) / Double(recent.count)
                        let variance = recent.map { pow($0.x - avgX, 2) + pow($0.y - avgY, 2) }.reduce(0, +) / Double(recent.count)
                        self.faceMoving = variance > 0.001
                    }
                } else {
                    self.faceDetected = false
                    self.faceMoving = false
                }
                self.updateCaptureStatus()
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: frame.capturedImage, orientation: .leftMirrored)
        try? handler.perform([request])
    }

    
    func updateCaptureStatus() {
        let allGood = faceDetected && !faceMoving && !deviceMoving && lightingGood

        DispatchQueue.main.async {
            self.canCapture = allGood

            let newMessage: String
            if !self.faceDetected {
                newMessage = "No face detected. Make sure your face is in screen."
            } else if self.faceMoving {
                newMessage = "Keep your face still."
            } else if self.deviceMoving {
                newMessage = "Keep device steady."
            } else if !self.lightingGood {
                newMessage = "Improve lighting conditions."
            } else {
                newMessage = "Perfect! Ready to draw. Face Paint is visible!"
            }

            if self.warningMessage != newMessage {
                self.warningMessage = newMessage
            }
        }
    }

    func captureARPhoto() {
        showSuccessAlert = true
    }
}
