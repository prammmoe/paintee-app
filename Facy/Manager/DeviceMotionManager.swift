//
//  DeviceMotionManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import CoreMotion

class DeviceMotionManager {
    private let externalCoreMotionManager = CMMotionManager()
    private var externalCoreMotionlastAccelerometerData: CMAccelerometerData?
    
    var onDeviceMotionUpdate: ((Bool) -> Void)? // isMoving
    
    func startDeviceMovementMonitoring() {
        guard externalCoreMotionManager.isAccelerometerAvailable else { return }
        
        externalCoreMotionManager.accelerometerUpdateInterval = 0.1
        externalCoreMotionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self = self, let data = data else { return }
            
            var isMoving = false
            if let last = self.externalCoreMotionlastAccelerometerData {
                let deltaX = abs(data.acceleration.x - last.acceleration.x)
                let deltaY = abs(data.acceleration.y - last.acceleration.y)
                let deltaZ = abs(data.acceleration.z - last.acceleration.z)
                isMoving = (deltaX + deltaY + deltaZ) > 0.3
            }
            
            self.externalCoreMotionlastAccelerometerData = data
            self.onDeviceMotionUpdate?(isMoving)
        }
    }
    
    func stopDeviceMovementMonitoring() {
        externalCoreMotionManager.stopAccelerometerUpdates()
    }
}
