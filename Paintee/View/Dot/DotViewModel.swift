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
import UIKit

class DotViewModel: ObservableObject {
    @Published var warningMessage = "Position your face for setup before you start outlining"
    @Published var canStartDotting = false
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
        let previousCanStartDotting = canStartDotting
        canStartDotting = allConditionMet

        let newMessage: String
        if !faceDetected {
            newMessage = "No face detected.\nMake sure your face is in the screen."
        } else if faceMoving {
            newMessage = "Keep your face still."
        } else if deviceMoving {
            newMessage = "Keep device steady."
        } else if !lightingGood {
            newMessage = "Improve lighting conditions."
        } else {
            newMessage = "Perfect!\n Follow the dots and mark your face!"
        }

        // Haptic
        if warningMessage != newMessage {
            warningMessage = newMessage
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            if allConditionMet {
                generator.notificationOccurred(.success)
            } else {
                generator.notificationOccurred(.error)
            }
        }

        // Extra haptic based on startDotting status
        if previousCanStartDotting != canStartDotting {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    func stopMonitoring() {
        service.stopDeviceMovementMonitoring()
    }
}
