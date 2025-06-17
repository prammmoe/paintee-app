//
//  ARViewManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import ARKit
import RealityKit

// ARViewContainer dengan proper lifecycle management
struct ARViewManager: UIViewRepresentable {
//    @Binding var isActive: Bool
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        
        guard ARFaceTrackingConfiguration.isSupported else { fatalError() }
        sceneView.delegate = context.coordinator
        
        // Store reference to sceneView in coordinator
        context.coordinator.sceneView = sceneView
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
//        if !isActive {
//            uiView.session.pause()
//            uiView.scene.rootNode.enumerateChildNodes { (node, _) in
//                node.removeFromParentNode()
//            }
//        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // Called when the view is being removed
    static func dismantleUIView(_ uiView: ARSCNView, coordinator: Coordinator) {
        print("🔥 ARView dismantled, pausing session")
        // Pause the AR session
        uiView.session.pause()
        
        // Remove all child nodes
        uiView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        
        // Clear the delegate
        uiView.delegate = nil
    }
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        weak var sceneView: ARSCNView?
        
        deinit {
            // Ensure session is paused when coordinator is deallocated
            sceneView?.session.pause()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let device = renderer.device else {
                return nil
            }
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                return nil
            }
            
            let node = SCNNode()
            
            // Tambahkan star painting ke kedua pipi
            addCheekPaintings(to: node, faceAnchor: faceAnchor)
            
            return node
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                return
            }
            
            // Update posisi star painting di kedua pipi
            updateCheekPaintings(node: node, faceAnchor: faceAnchor)
        }
        
        // MARK: - Cheek Painting Functions
        
        func addCheekPaintings(to node: SCNNode, faceAnchor: ARFaceAnchor) {
            // Tambahkan bintang di pipi kiri dan kanan
            addStarToCheek(to: node, faceAnchor: faceAnchor, isLeftCheek: true)
            addStarToCheek(to: node, faceAnchor: faceAnchor, isLeftCheek: false)
        }
        
        func updateCheekPaintings(node: SCNNode, faceAnchor: ARFaceAnchor) {
            // Update posisi bintang di pipi kiri dan kanan
            updateCheekPainting(node: node, faceAnchor: faceAnchor, paintingName: "left_star", isLeftCheek: true)
            updateCheekPainting(node: node, faceAnchor: faceAnchor, paintingName: "right_star", isLeftCheek: false)
        }
        
        func addStarToCheek(to node: SCNNode, faceAnchor: ARFaceAnchor, isLeftCheek: Bool) {
            // Buat star shape
            let starPath = createStarPath()
            let starGeometry = SCNShape(path: starPath, extrusionDepth: 0.001)
            
            // 🎨 Style bintang jadi kuning cerah
            starGeometry.firstMaterial?.diffuse.contents = UIColor.systemYellow
            starGeometry.firstMaterial?.emission.contents = UIColor.yellow
            starGeometry.firstMaterial?.specular.contents = UIColor.white
            
            let starNode = SCNNode(geometry: starGeometry)
            starNode.name = isLeftCheek ? "left_star" : "right_star"

            // 📍 Posisikan di pipi
            let cheekPosition = calculateCheekPosition(faceAnchor: faceAnchor, isLeftCheek: isLeftCheek)
            starNode.position = cheekPosition

            // 🪄 Skala
            starNode.scale = SCNVector3(0.015, 0.015, 0.015)

            // 🎯 Rotasi agar menghadap kamera (tampil datar ke depan)
            starNode.eulerAngles = SCNVector3(0, 0, 0)

            node.addChildNode(starNode)
        }

//        func addHeartToCheek(to node: SCNNode, faceAnchor: ARFaceAnchor, isLeftCheek: Bool) {
//            // Buat heart shape
//            let heartPath = createHeartPath()
//            let heartGeometry = SCNShape(path: heartPath, extrusionDepth: 0.001)
//            
//            // Style untuk hati
//            heartGeometry.firstMaterial?.diffuse.contents = UIColor.systemPink
//            heartGeometry.firstMaterial?.emission.contents = UIColor.red
//            heartGeometry.firstMaterial?.specular.contents = UIColor.white
//            
//            let heartNode = SCNNode(geometry: heartGeometry)
//            heartNode.name = isLeftCheek ? "left_heart" : "right_heart"
//            
//            // Posisikan di pipi
//            let cheekPosition = calculateCheekPosition(faceAnchor: faceAnchor, isLeftCheek: isLeftCheek)
//            heartNode.position = cheekPosition
//            
//            // Scale dan rotasi
//            heartNode.scale = SCNVector3(0.015, 0.015, 0.015)
//            heartNode.eulerAngles = SCNVector3(-Float.pi/2, 0, 0)
//            
//            node.addChildNode(heartNode)
//        }
        
        func updateCheekPainting(node: SCNNode, faceAnchor: ARFaceAnchor, paintingName: String, isLeftCheek: Bool) {
            guard let paintingNode = node.childNode(withName: paintingName, recursively: false) else {
                return
            }
            
            let cheekPosition = calculateCheekPosition(faceAnchor: faceAnchor, isLeftCheek: isLeftCheek)
            paintingNode.position = cheekPosition
        }
        
        func calculateCheekPosition(faceAnchor: ARFaceAnchor, isLeftCheek: Bool) -> SCNVector3 {
            // Vertices untuk pipi kiri dan kanan (approximate)
            let leftCheekIndices = [454, 455, 456, 457, 476] // Approximate left cheek vertices
            let rightCheekIndices = [874, 875, 876, 877, 894] // Approximate right cheek vertices
            
            let cheekIndices = isLeftCheek ? leftCheekIndices : rightCheekIndices
            
            var totalPosition = SCNVector3(0, 0, 0)
            var validVertices = 0
            
            for index in cheekIndices {
                if index < faceAnchor.geometry.vertices.count {
                    let vertex = faceAnchor.geometry.vertices[index]
                    totalPosition.x += vertex.x
                    totalPosition.y += vertex.y
                    totalPosition.z += vertex.z
                    validVertices += 1
                }
            }
            
            if validVertices > 0 {
                totalPosition.x /= Float(validVertices)
                totalPosition.y /= Float(validVertices)
                totalPosition.z /= Float(validVertices)
                
                // Offset ke depan agar tidak tertanam di wajah
                totalPosition.z += 0.005
            }
            
            return totalPosition
        }
        
        func createHeartPath() -> UIBezierPath {
            let heartPath = UIBezierPath()
            let scale: CGFloat = 1.0
            
            // Mulai dari bawah hati
            heartPath.move(to: CGPoint(x: 0, y: -0.6 * scale))
            
            // Sisi kiri hati
            heartPath.addCurve(to: CGPoint(x: -0.6 * scale, y: 0.2 * scale),
                              controlPoint1: CGPoint(x: -0.3 * scale, y: -0.4 * scale),
                              controlPoint2: CGPoint(x: -0.6 * scale, y: -0.1 * scale))
            
            // Bulatan kiri atas
            heartPath.addCurve(to: CGPoint(x: -0.3 * scale, y: 0.5 * scale),
                              controlPoint1: CGPoint(x: -0.6 * scale, y: 0.4 * scale),
                              controlPoint2: CGPoint(x: -0.5 * scale, y: 0.5 * scale))
            
            // Ke tengah atas
            heartPath.addCurve(to: CGPoint(x: 0, y: 0.3 * scale),
                              controlPoint1: CGPoint(x: -0.1 * scale, y: 0.5 * scale),
                              controlPoint2: CGPoint(x: 0, y: 0.4 * scale))
            
            // Bulatan kanan atas
            heartPath.addCurve(to: CGPoint(x: 0.3 * scale, y: 0.5 * scale),
                              controlPoint1: CGPoint(x: 0, y: 0.4 * scale),
                              controlPoint2: CGPoint(x: 0.1 * scale, y: 0.5 * scale))
            
            // Sisi kanan hati
            heartPath.addCurve(to: CGPoint(x: 0.6 * scale, y: 0.2 * scale),
                              controlPoint1: CGPoint(x: 0.5 * scale, y: 0.5 * scale),
                              controlPoint2: CGPoint(x: 0.6 * scale, y: 0.4 * scale))
            
            // Kembali ke bawah
            heartPath.addCurve(to: CGPoint(x: 0, y: -0.6 * scale),
                              controlPoint1: CGPoint(x: 0.6 * scale, y: -0.1 * scale),
                              controlPoint2: CGPoint(x: 0.3 * scale, y: -0.4 * scale))
            
            heartPath.close()
            return heartPath
        }
        
        func createStarPath() -> UIBezierPath {
            let starPath = UIBezierPath()
            let center = CGPoint(x: 0, y: 0)
            let outerRadius: CGFloat = 1.0
            let innerRadius: CGFloat = 0.4
            let numberOfPoints = 5
            
            for i in 0..<numberOfPoints * 2 {
                let angle = CGFloat(i) * .pi / CGFloat(numberOfPoints)
                let radius = i % 2 == 0 ? outerRadius : innerRadius
                
                let x = center.x + cos(angle - .pi/2) * radius
                let y = center.y + sin(angle - .pi/2) * radius
                
                if i == 0 {
                    starPath.move(to: CGPoint(x: x, y: y))
                } else {
                    starPath.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            starPath.close()
            return starPath
        }

    }
}
