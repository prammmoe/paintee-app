//
//  StepTwo.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ConnectDotView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showPreviewImage = true
    @StateObject private var sessionManager = ARFaceSessionManager.shared
    let asset: FacePaintingAsset
    @EnvironmentObject private var router: Router
    @State private var viewAppeared = false
    
    var body: some View {
        ZStack {
            // AR View with toggle-able preview overlay
            ARFaceSessionContainer(showPreviewImage: showPreviewImage)
                .ignoresSafeArea(.all)
                .id("ARContainer_\(viewAppeared ? "active" : "inactive")") // Force refresh
            
            VStack {
                Text("Start connecting the dots and make the outline!")
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
                        router.navigate(to: .drawingview(asset: asset))
                    } label: {
                        Text("Continue")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.pCream)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.pBlue)
                            .cornerRadius(15)
                    }
                    .accessibilityLabel("1. Continue")
                    .accessibilityIdentifier("ConnectContinueButton")
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
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
                Text("Step 2 of 3")
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
                sessionManager.applyAsset(asset, type: .outline)
            }
        }
        .onDisappear {
            viewAppeared = false
        }
    }
}
