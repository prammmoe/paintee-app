//
//  ARViewContainer.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 01/07/25.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @EnvironmentObject var arManager: ARManager
    
    func makeUIView(context: Context) -> ARView {
        return arManager.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
    }
}
