//
//  FaceDetectionManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import Vision
import ARKit

class FaceDetectionManager {
    private var facePositionHistory: [CGPoint] = []
    private var lastDetectionTime = Date()
    
    var onFaceDetectionResult: ((Bool, Bool) -> Void)? // (faceDetected, faceMoving)
    
    func detectFace(in frame: CVPixelBuffer) {
        let currentTime = Date()
        guard currentTime.timeIntervalSince(lastDetectionTime) > 0.1 else { return }
        lastDetectionTime = currentTime
        
        let request = VNDetectFaceRectanglesRequest { [weak self] request, _ in
            guard let self = self else { return }
            
            if let results = request.results as? [VNFaceObservation], let face = results.first {
                let current = CGPoint(x: face.boundingBox.midX, y: face.boundingBox.midY)
                self.facePositionHistory.append(current)
                if self.facePositionHistory.count > 10 {
                    self.facePositionHistory.removeFirst()
                }
                
                var faceMoving = false
                if self.facePositionHistory.count > 5 {
                    let recent = Array(self.facePositionHistory.suffix(5))
                    let avgX = recent.map { $0.x }.reduce(0, +) / Double(recent.count)
                    let avgY = recent.map { $0.y }.reduce(0, +) / Double(recent.count)
                    let variance = recent.map { pow($0.x - avgX, 2) + pow($0.y - avgY, 2) }.reduce(0, +) / Double(recent.count)
                    faceMoving = variance > 0.001
                }
                
                self.onFaceDetectionResult?(true, faceMoving)
            } else {
                self.onFaceDetectionResult?(false, false)
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: frame, orientation: .leftMirrored)
        try? handler.perform([request])
    }
}
