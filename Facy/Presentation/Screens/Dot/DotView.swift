//
//  FaceDetectionView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 14/06/25.
//
import SwiftUI
import Vision
import AVFoundation
// MARK: - Enhanced Face Detection View with AR Stars
struct DotView: View {
    @StateObject private var coordinator = ARFacePaintCoordinator()
    
    var body: some View {
        ZStack {
            // AR Camera Preview with Stars (full screen)
            ARFacePaintManager(coordinator: coordinator)
                .ignoresSafeArea()
            
            // UI Elements Overlay
            VStack {
                // Top warning area
                VStack {
                    Text(coordinator.warningMessage)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Bottom controls
                VStack(spacing: 16) {
                
                    
                    // AR Status Indicator
                    if coordinator.canCapture {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Stars Active!")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(20)
                    }
                    
                    // Capture Button
                    Button(action: {
                        captureARPhoto()
                    }) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(coordinator.canCapture ? Color.green : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(!coordinator.canCapture)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
        }
        .navigationTitle("Position Your Face")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // AR session starts automatically with ARFacePaintManager
        }
        .onDisappear {
            // AR session stops automatically when view disappears
        }
        .alert("Photo Captured", isPresented: $coordinator.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Face with stars captured successfully!")
        }
        .alert("Error", isPresented: $coordinator.showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(coordinator.errorMessage)
        }
    }
    
    // MARK: - AR Photo Capture Function
    private func captureARPhoto() {
        // We can implement AR scene capture here
        // For now, we'll just trigger the success alert
        coordinator.showSuccessAlert = true
    }
}

// MARK: - Status Indicator Component (unchanged)
struct StatusIndicator: View {
    let title: String
    let isGood: Bool
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isGood ? .green : .red)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.black.opacity(0.6))
        .cornerRadius(8)
    }
}

//// MARK: - Camera Preview Component
//struct CameraPreview: UIViewRepresentable {
//    let cameraManager: UnifiedCameraManager
//    
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        cameraManager.setupCameraPreview(in: view) // Setup camera preview
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}

#Preview {
    DotView()
}
