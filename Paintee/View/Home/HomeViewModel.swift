//
//  HomeViewModel.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var assets: [FacePaintingAsset] = []
    @Published var selectedAsset: FacePaintingAsset?

    private let service: FacePaintingAssetServiceProtocol

    init(service: FacePaintingAssetServiceProtocol = FacePaintingAssetServiceImpl()) {
        self.service = service
        loadAllAssets()
    }

    func loadAllAssets() {
        self.assets = service.getAllFacePaintingAsset()
    }

    func selectAsset(by id: UUID) {
        selectedAsset = service.getFacePaintingAssetById(id: id)
    }

    func selectAsset(by name: String) {
        selectedAsset = service.getFacePaintingAssetByName(name: name)
    }
}
