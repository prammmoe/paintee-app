//
//  StaticFacePaintingManager.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import SwiftUI

// Repository Implementation
class FacePaintingAssetServiceImpl: FacePaintingAssetServiceProtocol {
    let dummyData = FacePaintingAsset.assetData()

    func getAllFacePaintingAsset() -> [FacePaintingAsset] {
        return dummyData
    }

    func getFacePaintingAssetById(id: UUID) -> FacePaintingAsset? {
        return dummyData.first { $0.id == id }
    }

    func getFacePaintingAssetByName(name: String) -> FacePaintingAsset? {
        return dummyData.first { $0.name.lowercased() == name.lowercased() }
    }
    
    // TODO: All face painting operation will goes here
}
