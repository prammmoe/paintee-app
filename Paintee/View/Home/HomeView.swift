//
//  HomeDesignColletion.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import UIKit

// The HomeView struct that displays the face painting design collection
struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel() // Use ViewModel
    @EnvironmentObject private var router: Router
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var hasCompletedOnboarding: Bool
    @EnvironmentObject private var purchaseManager: PurchaseManager // Purchase Manager
    
    private var isWideScreen: Bool {
        horizontalSizeClass == .regular || UIScreen.main.bounds.width > 600
    }
    
    private var gridColumns: [GridItem] {
        let columnCount = isWideScreen ? 3 : 2
        return Array(repeating: GridItem(.flexible(minimum: 150)), count: columnCount)
    }
    
    var body: some View {
        NavigationStack(path: $router.path)
        {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    Color(red: 34/255, green: 40/255, blue: 80/255),
                    Color(red: 10/255, green: 20/255, blue: 50/255)
                ]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 3) {
                    Spacer().frame(height: isWideScreen ? 85 : 65)
                    
                    // Titles
                    Text("Face Painting")
                        .font(.system(size: isWideScreen ? 44 : 36, weight: .heavy))
                        .foregroundColor(Color.pYellow)
                        .padding(.horizontal, isWideScreen ? 25 : 15)
                    
                    Text("Design Collection")
                        .font(.system(size: isWideScreen ? 44 : 36, weight: .heavy))
                        .foregroundColor(Color.pTurq)
                        .padding(.horizontal, isWideScreen ? 25 : 15)
                    
                    Text("Choose our creative and easy-to-draw face painting design collection.")
                        .font(.system(size: 18, weight: .light))
                        .fontWeight(.regular)
                        .foregroundColor(.pCream)
                        .padding([.top, .horizontal], isWideScreen ? 25 : 15)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 1)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: gridColumns, spacing: isWideScreen ? 35 : 25) {
                            ForEach(viewModel.assets, id: \.id) { asset in
                                let productID = asset.name == "Dia Muertos" ? "com.paintee.diademuertos" :
                                asset.name == "Tiger" ? "com.paintee.tiger" : nil
                                let isUnlocked = productID == nil || purchaseManager.unlockedProductIDs.contains(productID!)
                                Button {
                                    if isUnlocked {
                                        router.navigate(to: .previewview(asset: asset))
                                    } else if let id = productID {
                                        purchaseManager.purchase(productID: id) { success in
                                            if success { purchaseManager.unlockedProductIDs.insert(id) }
                                            else { print("Purchase failed") }
                                        }
                                    }
                                } label: {
                                    if isUnlocked {
                                        DesignCard(asset: asset, isWideScreen: isWideScreen)
                                    } else {
                                        // Use LockedDesignCard for locked state
                                        LockedDesignCard(asset: asset, isWideScreen: isWideScreen, title: asset.name, lockImageName: "lockIcon")
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, isWideScreen ? 60 : 45)
                    
                    Spacer()
                }
                .padding(.horizontal, isWideScreen ? 25 : 15)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
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
        .tint(.white)
    }
}

// DesignCard struct that represents a single face painting design card
struct DesignCard: View {
    let asset: FacePaintingAsset
    var isWideScreen: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.pCream
                .shadow(radius: 5)
                .cornerRadius(25) // Apply cornerRadius to entire card
            Image(asset.homeImage)
                .resizable()
                .scaledToFit()
                .frame(width: isWideScreen ? 160 : 130, height: isWideScreen ? 200 : 165)
                .padding(.bottom, 15)
            
            Color.pYellow
                .frame(width: isWideScreen ? 180 : 160, height: 30)
                .cornerRadius(25, corners: [.bottomLeft, .bottomRight]) // Apply custom corner radius to bottom corners
                .overlay(
                    Text(asset.name)
                        .font(.system(size: isWideScreen ? 22 : 20, weight: .bold))
                        .foregroundColor(.pBlue)
                )
        }
        .frame(width: isWideScreen ? 180 : 160, height: isWideScreen ? 210 : 184)
        .padding(5)
    }
}

// Custom Rounded Corner to apply corner radius only to specified corners
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Extension to apply corner radius only to specified corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct LockedDesignCard: View {
    let asset: FacePaintingAsset
    var isWideScreen: Bool
    var title: String
    var lockImageName: String = "lockIcon"
    
    var body: some View {
        ZStack {
            Color.pCream
                .cornerRadius(25)
                .shadow(radius: 5)
            
            // Blurred/faded asset image
            Image(asset.homeImage)
                .resizable()
                .scaledToFit()
                .frame(width: isWideScreen ? 160 : 130, height: isWideScreen ? 200 : 165)
                .opacity(0.3) // fade
                .blur(radius: 2) // blur
            
            // Lock overlay
            VStack {
                Spacer()
                Image(lockImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .opacity(0.7)
                Spacer()
            }
            
            // "Buy to Unlock" text centered
            VStack {
                Spacer()
                Text("Buy to Unlock")
                    .font(.system(size: isWideScreen ? 18 : 16, weight: .bold))
                    .foregroundColor(.pBlue)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            // Bottom label
            VStack {
                Spacer()
                Color.pYellow
                    .frame(height: 30)
                    .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                    .overlay(
                        Text(title)
                            .font(.system(size: isWideScreen ? 22 : 20, weight: .bold))
                            .foregroundColor(.pBlue)
                    )
            }
        }
        .frame(width: isWideScreen ? 180 : 160, height: isWideScreen ? 210 : 184)
        .padding(5)
    }
}
