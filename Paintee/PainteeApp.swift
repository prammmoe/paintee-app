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
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            }
        }
        .environmentObject(router)
    }
}

