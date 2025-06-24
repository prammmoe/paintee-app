//
//  DotDetectionServiceImplementation.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import ARKit

class DotCalibrationServiceImpl: DotCalibrationServiceProtocol {
    private let faceDetectionManager: FaceDetectionManager
    private let deviceMotionManager: DeviceMotionManager
    
    var onDetectionUpdate: ((Bool, Bool, Bool) -> Void)?
    
    private var currentFaceDetected = false
    private var currentFaceMoving = false
    private var currentDeviceMoving = false
    
    init(
        faceDetectionManager: FaceDetectionManager = FaceDetectionManager(),
        deviceMotionManager: DeviceMotionManager = DeviceMotionManager()
    ) {
        self.faceDetectionManager = faceDetectionManager
        self.deviceMotionManager = deviceMotionManager
        
        self.faceDetectionManager.onFaceDetectionResult = { [weak self] detected, moving in
            self?.currentFaceDetected = detected
            self?.currentFaceMoving = moving
            self?.notifyUpdate()
        }
        
        self.deviceMotionManager.onDeviceMotionUpdate = { [weak self] moving in
            self?.currentDeviceMoving = moving
            self?.notifyUpdate()
        }
    }
    
    func startDeviceMovementMonitoring() {
        deviceMotionManager.startDeviceMovementMonitoring()
    }
    
    func stopDeviceMovementMonitoring() {
        deviceMotionManager.stopDeviceMovementMonitoring()
    }
    
    func processFaceFrame(frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        faceDetectionManager.detectFace(in: pixelBuffer)
    }
    
    func isLightingGood(from frame: ARFrame) -> Bool {
        frame.lightEstimate?.ambientIntensity ?? 1000 > 200
    }
    
    private func notifyUpdate() {
        onDetectionUpdate?(currentFaceDetected, currentFaceMoving, currentDeviceMoving)
    }
}
