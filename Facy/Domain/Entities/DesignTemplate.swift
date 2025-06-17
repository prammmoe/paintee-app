//
//  DesignTemplate.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import ARKit

struct DesignTemplate {
    let id: UUID
    let name: String
    let thumbnailImageName: String
    let virtualPoints: [VirtualPoint] // Dots that represent the design outline
}

struct VirtualPoint {
    let id: Int // Vertex position
    let anchorLandmark: VNFaceLandmarkRegion
    let offset: CGPoint
}
