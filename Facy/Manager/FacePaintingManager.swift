//
//  StaticFacePaintingManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import SwiftUI

class FacePaintingManager: FacePaintingService {
    func getAllFacePaintingAsset() -> [FacePaintingAsset] {
        return staticFacePaintingAsset
    }

    func getFacePaintingAssetById(id: UUID) -> FacePaintingAsset? {
        return staticFacePaintingAsset.first { $0.id == id }
    }

    func getFacePaintingAssetByName(name: String) -> FacePaintingAsset? {
        return staticFacePaintingAsset.first { $0.name.lowercased() == name.lowercased() }
    }
    
    // TODO: All face painting operation will goes here
}
