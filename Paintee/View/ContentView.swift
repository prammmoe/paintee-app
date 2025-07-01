//
//  ContentView.swift
//  Paintee
//
//  Created by Pramuditha Muhammad Ikhwan on 01/07/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: Router
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        NavigationStack(path: $router.path) {
            VStack {
                if hasCompletedOnboarding {
                    HomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                } else {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .onboardingview:
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                case .homeview:
                    HomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                case .drawingsteptutorialview(let asset):
                    DrawingStepTutorialView(asset: asset)
                case .camerasnapview:
                    CameraSnapView()
                case .previewview, .dotview, .connectdotview, .drawingview:
                    // These should not appear in static navigation
                    EmptyView()
                }
            }
            .fullScreenCover(
                item: Binding(
                    get: { router.currentARRoute },
                    set: { newValue in
                        if newValue == nil {
                            router.currentARRoute = nil
                        }
                    }
                )
            ) { arRoute in
                ARFlowRouter(arRoute: arRoute)
                    .environmentObject(router)
            }
            .tint(.white)
        }
    }
}
