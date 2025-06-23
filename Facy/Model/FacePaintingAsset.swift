//
//  FacePaintingAsset.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import SwiftUI

struct FacePaintingAsset: Equatable, Identifiable {
    var id = UUID()
    var name: String
    var previewImage: String
    var dotPreviewImage: String
    var outlinePreviewImage: String
}

// Static Data
let staticFacePaintingAsset: [FacePaintingAsset] = [
    FacePaintingAsset(
        name: "Clown",
        previewImage: "clown",
        dotPreviewImage: "circle.fill",
        outlinePreviewImage: "circle.dashed"
    ),
    FacePaintingAsset(
        name: "Halal Malaysia",
        previewImage: "halalmy",
        dotPreviewImage: "circle.fill",
        outlinePreviewImage: "circle.dashed"
    ),
    FacePaintingAsset(
        name: "Dragon Design",
        previewImage: "dragon",
        dotPreviewImage: "circle.fill",
        outlinePreviewImage: "circle.dashed"
    )
]

