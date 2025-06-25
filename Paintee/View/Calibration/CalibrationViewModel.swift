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

class CalibrationViewModel: ObservableObject {
    @Published var warningMessage = "Position your face for setup before you start outlining"
    @Published var canCapture = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    @Published var faceDetected = false
    @Published var faceMoving = false
    @Published var deviceMoving = false
    @Published var lightingGood = true
    
    private var service: DotCalibrationServiceProtocol
    
    init(service: DotCalibrationServiceProtocol = DotCalibrationServiceImpl()) {
        self.service = service
        
        self.service.onDetectionUpdate = { [weak self] faceDetected, faceMoving, deviceMoving in
            DispatchQueue.main.async {
                self?.faceDetected = faceDetected
                self?.faceMoving = faceMoving
                self?.deviceMoving = deviceMoving
                self?.updateCaptureStatus()
            }
        }
        
        service.startDeviceMovementMonitoring()
    }
    
    func analyzeFrame(_ frame: ARFrame) {
        lightingGood = service.isLightingGood(from: frame)
        service.processFaceFrame(frame: frame)
    }
    
    func updateCaptureStatus() {
        let allConditionMet = faceDetected && !faceMoving && !deviceMoving && lightingGood
        canCapture = allConditionMet
        
        let newMessage: String
        if !faceDetected {
            newMessage = "No face detected. Make sure your face is in screen."
        } else if faceMoving {
            newMessage = "Keep your face still."
        } else if deviceMoving {
            newMessage = "Keep device steady."
        } else if !lightingGood {
            newMessage = "Improve lighting conditions."
        } else {
            newMessage = "Perfect! Ready to draw!"
        }
        
        if warningMessage != newMessage {
            warningMessage = newMessage
        }
    }
    
    func captureARPhoto() {
        showSuccessAlert = true
    }
}
