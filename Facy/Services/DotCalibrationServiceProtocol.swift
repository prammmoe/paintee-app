//
//  DotDetectionServiceProtocol.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import ARKit

protocol DotCalibrationServiceProtocol {
    var onDetectionUpdate: ((Bool, Bool, Bool) -> Void)? { get set }
    
    func startDeviceMovementMonitoring()
    func stopDeviceMovementMonitoring()
    func processFaceFrame(frame: ARFrame)
    func isLightingGood(from frame: ARFrame) -> Bool
}
