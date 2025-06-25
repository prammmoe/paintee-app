//
//  PreviewCapture.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import Photos

struct PreviewCapture: View {
    let image: UIImage
    @Binding var capturedImage: UIImage?
    @State private var showSaveAlert = false

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()

                HStack(spacing: 16) {
                    Button(action: {
                        // RETAKE
                        capturedImage = nil
                    }) {
                        Text("Retake")
                            .frame(width: 140, height: 50)
                            .background(Color("just-blue"))
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .cornerRadius(15)
                    }

                    Button(action: {
                        saveImageToGallery(image)
                    }) {
                        Text("Save Image")
                            .frame(width: 140, height: 50)
                            .background(Color("dark-blue"))
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: HomeView()) {
                        Text("Home")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.blue)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(Color("dark-yellow"))
//                            .cornerRadius(15)
                }
              
            }
        }
        .alert("Saved!", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your photo has been saved to the gallery.")
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
