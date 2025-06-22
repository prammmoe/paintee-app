//
//  ARFacePaintManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 18/06/25.
//

/**
 This manager manages ARView for PreviewView and DotView
 */

import SwiftUI
import ARKit
import SceneKit
import Vision
import CoreMotion

// MARK: - ARFacePaintCoordinator (from previous artifact)
class ARFacePaintCoordinator: NSObject, ARSessionDelegate, ObservableObject, ARSCNViewDelegate {
    @Published var warningMessage = "Position your face for setup before you start outlining"
    @Published var canCapture = false
    @Published var showSuccessAlert = false
    @Published var showErrorAlert = false
    @Published var errorMessage = ""

    @Published var faceDetected = false
    @Published var faceMoving = false
    @Published var deviceMoving = false
    @Published var lightingGood = true

    private var facePositionHistory: [CGPoint] = []
    private let motionManager = CMMotionManager()
    private var lastAccelerometerData: CMAccelerometerData?
    weak var sceneView: ARSCNView?

    override init() {
        super.init()
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

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        detectLighting(frame: frame)
        detectFace(frame: frame)
    }

    private func detectLighting(frame: ARFrame) {
        let lightEstimate = frame.lightEstimate
        lightingGood = lightEstimate?.ambientIntensity ?? 1000 > 200
    }

    private func detectFace(frame: ARFrame) {
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

    private func updateCaptureStatus() {
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
                newMessage = "Perfect! Ready to draw. ⭐ Stars visible!"
            }

            if self.warningMessage != newMessage {
                self.warningMessage = newMessage
            }
        }
    }

    // MARK: - ARSCNViewDelegate Methods
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = renderer.device else {
            return nil
        }
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return nil
        }
        
        let node = SCNNode()
        
        // Add star paintings to both cheeks
        addCheekPaintings(to: node, faceAnchor: faceAnchor)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        
        // Update star painting positions on both cheeks
        updateCheekPaintings(node: node, faceAnchor: faceAnchor)
    }
    
    // MARK: - Cheek Painting Functions
    
    func addCheekPaintings(to node: SCNNode, faceAnchor: ARFaceAnchor) {
        // Add stars to left and right cheeks
        addStarToCheek(to: node, faceAnchor: faceAnchor, isLeftCheek: true)
        addStarToCheek(to: node, faceAnchor: faceAnchor, isLeftCheek: false)
    }
    
    func updateCheekPaintings(node: SCNNode, faceAnchor: ARFaceAnchor) {
        // Update star positions on left and right cheeks
        updateCheekPainting(node: node, faceAnchor: faceAnchor, paintingName: "left_star", isLeftCheek: true)
        updateCheekPainting(node: node, faceAnchor: faceAnchor, paintingName: "right_star", isLeftCheek: false)
    }
    
    func addStarToCheek(to node: SCNNode, faceAnchor: ARFaceAnchor, isLeftCheek: Bool) {
        // Create star shape
        let starPath = createStarPath()
        let starGeometry = SCNShape(path: starPath, extrusionDepth: 0.001)
        
        // Style star with bright yellow
        starGeometry.firstMaterial?.diffuse.contents = UIColor.systemYellow
        starGeometry.firstMaterial?.emission.contents = UIColor.yellow
        starGeometry.firstMaterial?.specular.contents = UIColor.white
        
        let starNode = SCNNode(geometry: starGeometry)
        starNode.name = isLeftCheek ? "left_star" : "right_star"

        // Position on cheek
        let cheekPosition = calculateCheekPosition(faceAnchor: faceAnchor, isLeftCheek: isLeftCheek)
        starNode.position = cheekPosition

        // Scale
        starNode.scale = SCNVector3(0.015, 0.015, 0.015)

        // Rotation to face camera (appear flat forward)
        starNode.eulerAngles = SCNVector3(0, 0, 0)

        node.addChildNode(starNode)
    }
    
    func updateCheekPainting(node: SCNNode, faceAnchor: ARFaceAnchor, paintingName: String, isLeftCheek: Bool) {
        guard let paintingNode = node.childNode(withName: paintingName, recursively: false) else {
            return
        }
        
        let cheekPosition = calculateCheekPosition(faceAnchor: faceAnchor, isLeftCheek: isLeftCheek)
        paintingNode.position = cheekPosition
    }
    
    // Fungsi untuk menghitung posisi pipi kiri atau kanan berdasarkan ARFaceAnchor
    func calculateCheekPosition(faceAnchor: ARFaceAnchor, isLeftCheek: Bool) -> SCNVector3 {
        // Indeks vertex yang kira-kira mewakili pipi kiri dan kanan pada model wajah
        let leftCheekIndices = [454, 455, 456, 457, 476]   // Indeks untuk pipi kiri
        let rightCheekIndices = [874, 875, 876, 877, 894]  // Indeks untuk pipi kanan
        
        // Pilih indeks sesuai parameter isLeftCheek
        let cheekIndices = isLeftCheek ? leftCheekIndices : rightCheekIndices
        
        var totalPosition = SCNVector3(0, 0, 0) // Menyimpan penjumlahan semua posisi vertex
        var validVertices = 0 // Counter untuk vertex yang valid (ada dalam array)

        // Iterasi setiap indeks pipi
        for index in cheekIndices {
            // Pastikan indeks masih dalam jangkauan jumlah vertex
            if index < faceAnchor.geometry.vertices.count {
                let vertex = faceAnchor.geometry.vertices[index]
                // Tambahkan koordinat vertex ke total
                totalPosition.x += vertex.x
                totalPosition.y += vertex.y
                totalPosition.z += vertex.z
                validVertices += 1
            }
        }

        // Jika ada vertex yang valid, hitung rata-rata posisinya
        if validVertices > 0 {
            totalPosition.x /= Float(validVertices)
            totalPosition.y /= Float(validVertices)
            totalPosition.z /= Float(validVertices)
            
            // Tambahkan offset kecil ke arah depan agar tidak tertanam di wajah
            totalPosition.z += 0.005
        }

        return totalPosition
    }

    // Fungsi untuk membuat bentuk bintang menggunakan UIBezierPath
    func createStarPath() -> UIBezierPath {
        let starPath = UIBezierPath()
        let center = CGPoint(x: 0, y: 0) // Titik tengah bintang
        let outerRadius: CGFloat = 1.0   // Radius untuk titik luar bintang
        let innerRadius: CGFloat = 0.4   // Radius untuk titik dalam bintang
        let numberOfPoints = 5           // Bintang dengan 5 ujung

        // Loop untuk menggambar 10 titik (5 ujung dan 5 lekukan)
        for i in 0..<numberOfPoints * 2 {
            let angle = CGFloat(i) * .pi / CGFloat(numberOfPoints) // Sudut untuk titik ke-i
            let radius = i % 2 == 0 ? outerRadius : innerRadius    // Gunakan radius luar untuk ujung, dalam untuk lekukan

            // Hitung koordinat titik dengan rotasi agar ujung menghadap ke atas
            let x = center.x + cos(angle - .pi/2) * radius
            let y = center.y + sin(angle - .pi/2) * radius

            if i == 0 {
                starPath.move(to: CGPoint(x: x, y: y)) // Mulai dari titik pertama
            } else {
                starPath.addLine(to: CGPoint(x: x, y: y)) // Tambahkan garis ke titik berikutnya
            }
        }

        starPath.close()
        return starPath
    }

    deinit {
        motionManager.stopAccelerometerUpdates()
        sceneView?.session.pause()
        sceneView = nil // Remove AR session from memory
    }
}

// MARK: - ARFacePaintManager (from previous artifact)
struct ARFacePaintManager: UIViewRepresentable {
    @ObservedObject var coordinator: ARFacePaintCoordinator

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.session.delegate = coordinator
        arView.delegate = coordinator
        coordinator.sceneView = arView

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    static func dismantleUIView(_ uiView: ARSCNView, coordinator: ()) {
        uiView.session.pause()
    }
}


