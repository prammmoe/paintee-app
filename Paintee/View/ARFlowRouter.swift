//
//  ARFlowRouter.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 01/07/25.
//

import SwiftUI

struct ARFlowRouter: View {
    @EnvironmentObject var router: Router
    let arRoute: ARRoute
    
    var body: some View {
        switch arRoute {
        case .previewview(let asset):
            PreviewView(asset: asset)
        case .dotview(let asset):
            DotView(asset: asset)
        case .connectdotview(let asset):
            ConnectDotView(asset: asset)
        case .drawingview(let asset):
            DrawingView(asset: asset)
        }
    }
}
