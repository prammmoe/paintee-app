//
//  HomeDesignColletion.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var router: Router
        
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 34/255, green: 40/255, blue: 80/255), Color(red: 10/255, green: 20/255, blue: 50/255)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 5) {
                    // Title
                    Text("Face Painting Design Collection")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(Color.orange)
                        .padding(.top, 70)
                        .padding(.horizontal, 15)
                    
                    // Subtitle
                    Text("Choose our creative and easy-to-draw face painting design collection.")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.white)
                        .padding([.top, .horizontal])
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 1)
                    
                    // Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 150)), count: 2), spacing: 14) {
                        ForEach(viewModel.assets, id: \.id) { asset in
//                            NavigationLink(destination: PreviewView(previewImage: asset.previewImage)) {
//                                DesignCard(asset: asset)
//                            }
//                            .buttonStyle(PlainButtonStyle())
                            Button {
                                router.navigate(to: .previewview(asset: asset))
                            } label: {
                                DesignCard(asset: asset)
                            }
                        }
                    }
                    .padding(.top, 25)
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .previewview(let asset):
                    PreviewView(asset: asset)
                case .connectdotview(let asset):
                    ConnectDotView(asset: asset)
                case .drawingview(let asset):
                    DrawingView(asset: asset)
                case .dotview(let asset):
                    DotView(asset: asset)
                }
            }
        }
    }
}

struct DesignCard: View {
    let asset: FacePaintingAsset
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.brown
                .cornerRadius(25)
            
            Image(asset.previewImage)
                .resizable()
                .scaledToFit()
                .frame(width: 126, height: 161)
                .padding(.bottom,15)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange)
                .frame(width: 135, height: 30)
                .overlay(
                    Text(asset.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                )
                .padding(.trailing)
        }
        .frame(width: 152, height: 184)
        .shadow(radius: 5)
        .padding(5)
    }
}

