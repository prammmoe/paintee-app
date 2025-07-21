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
    var isLocked: Bool = false
    
    static func assetData() -> [FacePaintingAsset] {
        return [
            // Tribal
            FacePaintingAsset(
                name: "Tribal",
                previewImage: "Tribal",
                dotPreviewImage: "TribalDot",
                outlinePreviewImage: "TribalOutline",
                homeImage: "design1"
            ),
            
            // Clown
            FacePaintingAsset(
                name: "Clown",
                previewImage: "Clown",
                dotPreviewImage: "ClownDot",
                outlinePreviewImage: "ClownOutline",
                homeImage: "design2"
            ),
            
            // Animal
            FacePaintingAsset(
                name: "Animal",
                previewImage: "Animal",
                dotPreviewImage: "AnimalDot",
                outlinePreviewImage: "AnimalOutline",
                homeImage: "design3"
            ),
            // Hero
            FacePaintingAsset(
                name: "Hero",
                previewImage: "Hero",
                dotPreviewImage: "HeroDot",
                outlinePreviewImage: "HeroOutline",
                homeImage: "design4"
            ),
            // Dia Muertos
            FacePaintingAsset(
                name: "Dia Muertos",
                previewImage: "Dia Muertos",
                dotPreviewImage: "MuertosDot",
                outlinePreviewImage: "MuertosOutline",
                homeImage: "design5",
                isLocked: true,
            ),
            // Tiger
            FacePaintingAsset(
                name: "Tiger",
                previewImage: "Tiger",
                dotPreviewImage: "TigerDot",
                outlinePreviewImage: "TigerOutline",
                homeImage: "design6",
                isLocked: true
            ),
            
        ]
    }
}
