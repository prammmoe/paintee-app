//
//  PreviewCapture.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import Photos

struct PreviewCapture: View {
    @EnvironmentObject private var router: Router
    let image: UIImage
    @Binding var capturedImage: UIImage?
    @State private var showSaveAlert = false
    @StateObject private var sessionManager = ARFaceSessionManager.shared
    
    private var mirroredImage: UIImage {
            guard
                let cg = image.cgImage
            else { return image }
            return UIImage(
                cgImage: cg,
                scale: image.scale,
                orientation: .leftMirrored
            )
        }
    
    var body: some View {
        ZStack {
            Image(uiImage: mirroredImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack(spacing: 25) {
                    Button(action: {
                        capturedImage = nil
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pCream)
                            .frame(width: 60, height: 60)
                            .background(Color.pBlue)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        saveImageToGallery(mirroredImage)
                    }) {
                        Image(systemName: "photo.badge.arrow.down")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.pBlue)
                            .frame(width: 80, height: 80)
                            .background(Color.pTurq)
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        router.reset()
                    }) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.pCream)
                            .frame(width: 60, height: 60)
                            .background(Color.pBlue)
                            .clipShape(Circle())
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 20)
            }
        }
        
        .alert("Saved!", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your photo has been saved to the gallery.")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .onChange(of: router.currentRoute) { oldRoute, newRoute in
            if newRoute == .homeview {
                sessionManager.stopSession()
            }
        }
    }
    
    private func saveImageToGallery(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                DispatchQueue.main.async {
                    showSaveAlert = true
                }
            } else {
                print("Photo access denied")
            }
        }
    }
}
