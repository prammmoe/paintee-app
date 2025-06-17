//
//  FaceDetectionView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 14/06/25.
//
import SwiftUI
import Vision
import AVFoundation

// MARK: - Enhanced Face Detection View (Modified)
struct DotView: View {
    @StateObject private var cameraManager = UnifiedCameraManager() // Use the new manager
    
    var body: some View {
        ZStack {
            // Camera Preview (full screen, no overlay)
            CameraPreview(cameraManager: cameraManager)
                .ignoresSafeArea()
            
            // UI Elements
            VStack {
                // Top warning area
                VStack {
                    Text(cameraManager.warningMessage)
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
                    // Status indicators
                    HStack(spacing: 20) {
                        StatusIndicator(
                            title: "Face",
                            isGood: cameraManager.faceDetected && !cameraManager.faceMoving,
                            icon: "face.smiling"
                        )
                        
                        StatusIndicator(
                            title: "Device",
                            isGood: !cameraManager.deviceMoving,
                            icon: "iphone"
                        )
                        
                        StatusIndicator(
                            title: "Light",
                            isGood: cameraManager.lightingGood,
                            icon: "sun.max"
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Capture Button
                    Button(action: {
                        cameraManager.capturePhoto()
                    }) {
                        Text("Continue to drawing step")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(cameraManager.canCapture ? Color.green : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(!cameraManager.canCapture)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
            }
        }
        .navigationTitle("Position Your Face")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            cameraManager.requestPermissionForCamera()
        }
        .onDisappear {
            cameraManager.stopAllSessions() // Stop all sessions when the view disappears
        }
        .alert("Photo Captured", isPresented: $cameraManager.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Face captured successfully!")
        }
        .alert("Error", isPresented: $cameraManager.showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(cameraManager.errorMessage)
        }
    }
}

// MARK: - Status Indicator Component
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

// MARK: - Camera Preview Component
struct CameraPreview: UIViewRepresentable {
    let cameraManager: UnifiedCameraManager
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        cameraManager.setupCameraPreview(in: view) // Setup camera preview
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    DotView()
}
