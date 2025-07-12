//
//  FacePaintingViewContainer.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct PreviewView: View {
    private static var didShowTutorialThisSession = false
    @Environment(\.dismiss) private var dismiss
    @State private var showTutorial = false
    @State private var showPreviewImage = true
    @State private var viewAppeared = false
    @State private var permissionDenied = false
    
    @StateObject private var sessionManager = ARFaceSessionManager.shared
    @EnvironmentObject private var router: Router
    
    let asset: FacePaintingAsset
    
    var body: some View {
        ZStack {
            ARFaceSessionContainer(showPreviewImage: showPreviewImage)
                .ignoresSafeArea(.all)
                .id("ARContainer_Preview_\(viewAppeared ? "active" : "inactive")")
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.navigate(
                            to: .dotview(asset: asset)
                        )
                    } label: {
                        Text("Continue with this design")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.pCream)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.pBlue)
                            .cornerRadius(15)
                    }
                    .disabled(showTutorial)
                    .opacity(showTutorial ? 0.5 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
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
                Text("Design Preview")
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
        .sheet(isPresented: $showTutorial) {
            DrawingStepTutorialView(asset: asset)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color.clear)
        .onAppear {
            viewAppeared = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                sessionManager.resumeSession()
                sessionManager.applyAsset(asset, type: .preview)
            }
        }
        .onDisappear {
            viewAppeared = false
        }
        .onChange(of: router.currentRoute) { oldRoute, newRoute in
            if newRoute == .homeview {
                sessionManager.stopSession()
            }
        }
        .onAppear {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            if !Self.didShowTutorialThisSession {
                                showTutorial = true
                                Self.didShowTutorialThisSession = true
                            }
                        } else {
                            permissionDenied = true
                        }
                    }
                }
            case .authorized:
                if !Self.didShowTutorialThisSession {
                    showTutorial = true
                    Self.didShowTutorialThisSession = true
                }
            case .denied, .restricted:
                permissionDenied = true
            @unknown default:
                break
            }
        }
        
        .alert("Camera Access Required",
               isPresented: $permissionDenied
        ) {
            Button("Open Settings") {
                guard let url = URL(string: UIApplication.openSettingsURLString)
                else { return }
                UIApplication.shared.open(url)
            }
            Button("Cancel", role: .cancel) {
                router.goBack()
            }
        } message: {
            Text("Please allow camera access in Settings to see the AR preview.")
        }
    }
}

struct TutorialSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.pBlue)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Preview your design!")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pBlue)
                
                Text("You can use this design or pick another.\nThe colors shown are just examples,\nfeel free to get creative!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pBlue)
            }
            .padding(.horizontal, 40)
            
            Button(action: {
                dismiss()
            }) {
                Text("Okay")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.pBlue)
                    .cornerRadius(15)
                
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 34)
            .accessibilityLabel("1. Continue")
            .accessibilityIdentifier("ConnectContinueButton")
        }
        .background(Color(.pCream))
        .presentationDetents([.fraction(0.40)])
        .presentationDragIndicator(.hidden)
    }
}

