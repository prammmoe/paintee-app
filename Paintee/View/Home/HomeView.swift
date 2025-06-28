//
//  HomeDesignColletion.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var router: Router
    
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
                
                VStack(alignment: .leading, spacing: 3) {
                    Spacer().frame(height: 65)
                    
                    Text("Face Painting")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(Color.pYellow)
                        .padding(.horizontal, 15)
                    
                    Text("Design Collection")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(Color.pTurq)
                        .padding(.horizontal, 15)
                    
                    Text("Choose our creative and easy-to-draw face painting design collection.")
                        .font(.system(size: 18, weight: .light))
                        .fontWeight(.regular)
                        .foregroundColor(.pCream)
                        .padding([.top, .horizontal])
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 1)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 150)), count: 2), spacing: 25) {
                        ForEach(Array(viewModel.assets.enumerated()), id: \.element.id) { index, asset in
                            Button {
                                router.navigate(to: .previewview(asset: asset))
                            } label: {
                                DesignCard(asset: asset)
                            }
                            .accessibilityLabel("\(index + 1). \(asset.name)")
                            .accessibilityIdentifier("DesignCard_\(asset.id.uuidString)")
                        }
                    }
                    .padding(.top, 45)
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
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

struct DesignCard: View {
    let asset: FacePaintingAsset
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.pCream
                .shadow(radius: 5)
                .cornerRadius(25)
            
            Image(asset.homeImage)
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 165)
                .padding(.bottom, 15)
            
            Color.pYellow
                .frame(width: 160, height: 30)
                .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                .overlay(
                    Text(asset.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.pBlue)
                )
        }
        .frame(width: 160, height: 184)
        .padding(5)
    }
}

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

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

#Preview {
    HomeView()
        .environmentObject(Router())
}
//jusr addesd something here
