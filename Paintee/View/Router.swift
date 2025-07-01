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

enum ARRoute: Hashable, Identifiable {
    case previewview(asset: FacePaintingAsset)
    case dotview(asset: FacePaintingAsset)
    case connectdotview(asset: FacePaintingAsset)
    case drawingview(asset: FacePaintingAsset)
    
    var id: String {
        switch self {
        case .previewview(let asset):
            return "preview_\(asset.id)"
        case .dotview(let asset):
            return "dot_\(asset.id)"
        case .connectdotview(let asset):
            return "connectdot_\(asset.id)"
        case .drawingview(let asset):
            return "drawing_\(asset.id)"
        }
    }
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentARRoute: ARRoute? = nil
    
    func navigate(to route: Route) {
        print("Navigating to: \(route)")
        
        // Check if this is an AR route
        switch route {
        case .previewview(let asset):
            currentARRoute = .previewview(asset: asset)
        case .dotview(let asset):
            currentARRoute = .dotview(asset: asset)
        case .connectdotview(let asset):
            currentARRoute = .connectdotview(asset: asset)
        case .drawingview(let asset):
            currentARRoute = .drawingview(asset: asset)
        default:
            // For static views, add to navigation path
            path.append(route)
        }
        
        print("Current Path Count: \(path.count)")
    }
    
    func exitARAndContinue(to route: Route) {
        // Exit AR and navigate to the next static view
        currentARRoute = nil
        path.append(route)
    }
    
    func exitARAndGoBack() {
        // Exit AR and go back to previous static view
        currentARRoute = nil
        // Don't modify path - just dismissing AR will show the previous static view
    }
    
    func goBack() {
        if currentARRoute != nil {
            // If we're in AR, just exit AR (go back to previous static view)
            currentARRoute = nil
        } else if !path.isEmpty {
            // If we're in static view, go back in navigation stack
            path.removeLast()
        }
    }
    
    func reset() {
        path = NavigationPath()
        currentARRoute = nil
    }
}
