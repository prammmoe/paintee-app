//
//  FacyApp.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 14/06/25.
//

import SwiftUI

@main
struct FacyApp: App {
    @StateObject private var router = Router()
    var body: some Scene {
        WindowGroup {
//            let facePaintingManager: FacePaintingService = FacePaintingAssetManager()
//            let viewModel = HomeViewModel(service: facePaintingManager)
//            
//            HomeView(viewModel: viewModel)
            HomeView()
        }
        .environmentObject(router)
    }
}
