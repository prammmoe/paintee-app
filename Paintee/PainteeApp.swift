//
//  PainteeApp.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 25/06/25.
//

import SwiftUI

@main
struct PainteeApp: App {
    @StateObject private var router = Router()
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
        .environmentObject(router)
    }
}

