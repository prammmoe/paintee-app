//
//  Router.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import SwiftUI

enum Route: Hashable {
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
    @Published var currentRoute: Route? = .homeview

    private var routeStack: [Route] = [.homeview]

    func navigate(to route: Route) {
        path.append(route)
        routeStack.append(route)
        currentRoute = route
        
        print("\n=== Path Count nav ===")
        print("Current path count is: \(path.count)")
        
        // Debug
        print("\n===Navigation Debug===")
        print("Navigating to \(route)")
    }

    func goBack() {
        guard !routeStack.isEmpty else { return }
        routeStack.removeLast()
        path.removeLast()
        currentRoute = routeStack.last ?? .homeview
        print(routeStack.last ?? .homeview)
        
        print("\n=== Path Count back ===")
        print("Current path count is: \(path.count)")
        
        // Debug
        print("Going back to \(currentRoute ?? .homeview)")
    }

    func reset() {
        path = NavigationPath()
        routeStack = [.homeview]
        currentRoute = .homeview
        
        // Debug
        print("Resetting to \(currentRoute ?? .homeview)")
    }
    
    func popToHome() {
        while routeStack.last != .homeview {
            if !routeStack.isEmpty {
                routeStack.removeLast()
                path.removeLast()
            } else {
                break
            }
        }
        currentRoute = .homeview
    }
}
