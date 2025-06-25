//
//  GetPaintingRepositories.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import Foundation
import SwiftUI

// Repository
protocol FacePaintingAssetServiceProtocol {
    func getAllFacePaintingAsset() -> [FacePaintingAsset]
    func getFacePaintingAssetById(id: UUID) -> FacePaintingAsset?
    func getFacePaintingAssetByName(name: String) -> FacePaintingAsset?
}
