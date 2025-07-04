//
//  StepThree.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct DrawingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTutorial = true
    @State private var showPreviewImage = true
    @EnvironmentObject private var router: Router
    let asset: FacePaintingAsset
    @State private var viewAppeared = false
    @StateObject private var sessionManager = ARFaceSessionManager.shared

    
    var body: some View {
        ZStack {
            ARFaceSessionContainer(showPreviewImage: showPreviewImage)
                .ignoresSafeArea(.all)
                .id("ARContainer_\(viewAppeared ? "active" : "inactive")") // Force refresh
            VStack {
                Text("Time to paint it all in!")
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
                        router.navigate(to: .camerasnapview)
                        print("Otw navigation to CameraSnapView")
                    } label: {
                        Text("Finish")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.pBlue)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.pTurq)
                            .cornerRadius(15)
                    }
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
                Text("Step 3 of 3")
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
                        .foregroundColor(showPreviewImage ? Color.yellow : .white)
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
            
            // Delay untuk memastikan view sudah ter-render
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
