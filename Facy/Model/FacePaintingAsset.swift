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
    var homeImage: String
    
    static func dummyData() -> [FacePaintingAsset] {
        return [
            FacePaintingAsset(
                name: "Clown",
                previewImage: "clown",
                dotPreviewImage: "circle.fill",
                outlinePreviewImage: "circle.dashed",
                homeImage: "design2"
            ),
            FacePaintingAsset(
                name: "Tribal",
                previewImage: "tribal",
                dotPreviewImage: "circle.fill",
                outlinePreviewImage: "circle.dashed",
                homeImage: "design1"
            ),
            FacePaintingAsset(
                name: "Fox",
                previewImage: "fox",
                dotPreviewImage: "circle.fill",
                outlinePreviewImage: "circle.dashed",
                homeImage: "design3"
            )
        ]
    }
}
