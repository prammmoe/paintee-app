//
//  FaceDetectionView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 14/06/25.
//
import SwiftUI
import ARKit
import RealityKit

struct DotView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = DotViewModel()
    @StateObject private var sessionManager = ARFaceSessionManager.shared
    let asset: FacePaintingAsset
    
    @EnvironmentObject private var router: Router
    @State private var navigateToStepOne = false
    @State private var showPreviewImage = true
    @State private var viewAppeared = false
    
    var body: some View {
        ZStack {
            ARFaceSessionContainer()
                .ignoresSafeArea(.all)
                .id("ARContainer_\(viewAppeared ? "active" : "inactive")") // Force refresh
            
            VStack {
                Text(viewModel.warningMessage)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.pYellow.opacity(0.8))
                    .cornerRadius(12)
                    .padding(.top, 125)
                
                Spacer()
            }
            .ignoresSafeArea(edges: .top)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.navigate(to: .connectdotview(asset: asset))
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.pCream)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.canStartDotting ? Color.pBlue : .pBlue.opacity(0.5))
                            .cornerRadius(15)
                    }
                    .accessibilityLabel("1. Continue")
                    .accessibilityIdentifier("ConnectContinueButton")
                    .animation(.easeInOut(duration: 0.2), value: viewModel.canStartDotting)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // Pastikan session tetap aktif saat navigasi back
                    router.goBack()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Step 1 of 3")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showPreviewImage.toggle()
                }) {
                    Image(systemName: "sparkles")
                        .font(.subheadline)
                        .foregroundColor(showPreviewImage ? .pYellow : .white)
                        .padding(7)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
            }
        }
        .toolbarBackground(Color.pBlue.opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewAppeared = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sessionManager.resumeSession()
                sessionManager.applyAsset(asset, type: .dot)
            }
        }
        .onDisappear {
            viewAppeared = false
        }
    }
}
