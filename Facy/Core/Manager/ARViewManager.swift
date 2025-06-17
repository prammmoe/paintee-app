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
            
            let faceGeometry = ARSCNFaceGeometry(device: device)
            let node = SCNNode(geometry: faceGeometry)

            node.geometry?.firstMaterial?.fillMode = .lines
            
            for x in 0..<faceAnchor.geometry.vertices.count {
                if x % 2 == 0 {
                    let text = SCNText(string: "\(x)", extrusionDepth: 1)
                    let textNode = SCNNode(geometry: text)
                    textNode.scale = SCNVector3(x: 0.00025, y: 0.00025, z: 0.00025)
                    textNode.name = "\(x)"
                    
                    // Set the text color to red
                    textNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                    
                    // Position the text node at the corresponding vertex
                    let vertex = SCNVector3(faceAnchor.geometry.vertices[x])
                    textNode.position = vertex
                    
                    node.addChildNode(textNode)
                }
            }
            
            return node
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor,
                  let faceGeometry = node.geometry as? ARSCNFaceGeometry
            else {
                return
            }
            
            faceGeometry.update(from: faceAnchor.geometry)
        
            for x in 0..<faceAnchor.geometry.vertices.count {
                if x % 2 == 0 {
                    let textNode = node.childNode(withName: "\(x)", recursively: false)
                    let vertex = SCNVector3(faceAnchor.geometry.vertices[x])
                    textNode?.position = vertex
                }
            }
        }
    }
}
