//
//  Router.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import SwiftUI

enum Route: Hashable {
    case onboardingview
    case homeview
    case previewview(asset: FacePaintingAsset)
    case drawingsteptutorialview(asset: FacePaintingAsset)
    case dotview(asset: FacePaintingAsset)
    case connectdotview(asset: FacePaintingAsset)
    case drawingview(asset: FacePaintingAsset)
    case camerasnapview
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
//        print("Navigating to: \(route)")
        path.append(route)
        print("Current Path Count: \(path.count)")
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
