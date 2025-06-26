//
//  FacePaintingAsset.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import SwiftUI

struct FacePaintingAsset: Hashable, Equatable, Identifiable {
    var id = UUID()
    var name: String
    var previewImage: String
    var dotPreviewImage: String
    var outlinePreviewImage: String
    var homeImage: String
    
    static func assetData() -> [FacePaintingAsset] {
        return [
            // Animal
            FacePaintingAsset(
                name: "Animal",
                previewImage: "Animal",
                dotPreviewImage: "AnimalDot",
                outlinePreviewImage: "AnimalOutline",
                homeImage: "design2"
            ),
            
            // Clown
            FacePaintingAsset(
                name: "Clown",
                previewImage: "Clown",
                dotPreviewImage: "ClownDot",
                outlinePreviewImage: "ClownOutline",
                homeImage: "design1"
            ),
            
            // Mask
            FacePaintingAsset(
                name: "Mask",
                previewImage: "Mask",
                dotPreviewImage: "MaskDot",
                outlinePreviewImage: "MaskOutline",
                homeImage: "design3"
            )
        ]
    }
}
