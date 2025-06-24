//
//  HomeDesignColletion.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
        
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 34/255, green: 40/255, blue: 80/255), Color(red: 10/255, green: 20/255, blue: 50/255)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 5) {
                    // Title
                    Text("Face Painting")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(Color.orange)
                        .padding(.top, 70)
                        .padding(.horizontal, 15)
                    Text("Design Collection")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(Color.lightBlue)
//                        .padding(.top, 70)
                        .padding(.horizontal, 15)
                    
                    // Subtitle
                    Text("Choose our creative and easy-to-draw face painting design collection.")
                        .font(.system(size: 18, weight: .light))
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .padding([.top, .horizontal])
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 1)
                    
                    // Grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 150)), count: 2), spacing: 14) {
                        ForEach(viewModel.assets, id: \.id) { asset in
                            NavigationLink(destination: PreviewView(previewImage: asset.previewImage)) {
                                DesignCard(asset: asset)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 25)
                    
                    Spacer()
                }
                .padding(.horizontal, 15)
            }
        }
    }
}

struct DesignCard: View {
    let asset: FacePaintingAsset
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.lightYellow
                .shadow(radius: 5)
                .cornerRadius(25)
//            ganti homeImage
//            Image(asset.previewImage)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 126, height: 161)
//                .padding(.bottom,15)
            Image(asset.homeImage)
                .resizable()
                .scaledToFit()
                .frame(width: 126, height: 161)
                .padding(.bottom,15)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange)
                .frame(width: 140, height: 30)
                .overlay(
                    Text(asset.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                )
                .padding(.trailing)
        }
        .frame(width: 152, height: 184)
//        .shadow(radius: 5)
        .padding(5)
    }
}
#Preview {
    HomeView()
}

