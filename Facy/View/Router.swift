//
//  Router.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import SwiftUI

enum Route: Hashable {
    case previewview(previewImage: String)
    case dotview(previewImage: String)
    case connectdotview(previewImage: String)
    case drawingview(previewImage: String)
}

class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func reset() {
        path = NavigationPath()
    }
}
