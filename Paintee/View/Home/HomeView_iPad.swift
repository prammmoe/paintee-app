//
//  HomeView_iPad.swift
//  Paintee
//
//  Created by Abdul Jabbar on 28/06/25.
//
import SwiftUI
import UIKit

struct HomeView_iPad: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var router: Router
    @Binding var hasCompletedOnboarding: Bool
    
    private var gridColumns: [GridItem] {
        let screenWidth = UIScreen.main.bounds.width
        let columnCount: Int
        
        if screenWidth >= 1200 {
            columnCount = 4
        } else {
            columnCount = 2
        }
        
        return Array(repeating: GridItem(.flexible(minimum: 150)), count: columnCount)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 34/255, green: 40/255, blue: 80/255),
                    Color(red: 10/255, green: 20/255, blue: 50/255)
                ]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer().frame(height: 80)
                    
                    Text("Face Painting")
                        .font(.system(size: 60, weight: .heavy))
                        .foregroundColor(Color.pYellow)
                        .padding(.horizontal, 100)
                    
                    Text("Design Collection")
                        .font(.system(size: 60, weight: .heavy))
                        .foregroundColor(Color.pTurq)
                        .padding(.horizontal, 100)
                    
                    Text("Choose our creative and easy-to-draw face painting design collection.")
                        .font(.title3)
                        .foregroundColor(.pCream)
                        .padding(.horizontal, 100)
                        .multilineTextAlignment(.leading)
                    
                    LazyVGrid(columns: gridColumns, spacing: 60) {
                        ForEach(Array(viewModel.assets.enumerated()), id: \.element.id) { index, asset in
                            Button {
                                router.navigate(to: .previewview(asset: asset))
                            } label: {
                                DesignCard_iPad(asset: asset)
                            }
                            .accessibilityLabel("\(index + 1). \(asset.name)")
                            .accessibilityIdentifier("DesignCard_\(asset.id.uuidString)")
                        }
                    }
                    .padding(.top, 40)
                    .padding(.horizontal,80)
                    
                    Spacer()
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .onboardingview:
                    OnboardingView(hasCompletedOnboarding: .constant(false))
                case .homeview:
                    HomeView(hasCompletedOnboarding: $hasCompletedOnboarding)
                case .previewview(let asset):
                    PreviewView(asset: asset)
                case .drawingsteptutorialview(let asset):
                    DrawingStepTutorialView(asset: asset)
                case .dotview(let asset):
                    DotView(asset: asset)
                case .connectdotview(let asset):
                    ConnectDotView(asset: asset)
                case .drawingview(let asset):
                    DrawingView(asset: asset)
                case .camerasnapview:
                    CameraSnapView()
                }
            }
        }
    }
}

struct DesignCard_iPad: View {
    let asset: FacePaintingAsset
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.pCream
                .shadow(radius: 7)
                .cornerRadius(30)
            
            Image(asset.homeImage)
                .resizable()
                .scaledToFit()
                .frame(width: 272, height: 306)
                .padding(.bottom, 50)
            
            Color.pYellow
                .frame(width: 350, height: 60)
                .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                .overlay(
                    Text(asset.name)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.pBlue)
                )
        }
        .frame(width: 350, height: 374)
        .padding(8)
    }
}

//#Preview {
//    HomeView_iPad()
//        .environmentObject(Router())
//}
