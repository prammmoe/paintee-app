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
    @StateObject private var coordinator = ARViewCoordinator() // pakai ARViewCoordinator

    var body: some View {
        ZStack {
            // AR Camera Preview (pakai ARView)
            ARViewManager(coordinator: coordinator)
                .ignoresSafeArea()

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
                    HStack(spacing: 20) {
                        StatusIndicator(
                            title: "Face",
                            isGood: coordinator.faceDetected && !coordinator.faceMoving,
                            icon: "face.smiling"
                        )
                        StatusIndicator(
                            title: "Device",
                            isGood: !coordinator.deviceMoving,
                            icon: "iphone"
                        )
                        StatusIndicator(
                            title: "Light",
                            isGood: coordinator.lightingGood,
                            icon: "sun.max"
                        )
                    }
                    .padding(.horizontal, 20)

                    Button(action: {
                        coordinator.showSuccessAlert = true
                    }) {
                        Text("Continue to drawing step")
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
        .onDisappear {
//            coordinator.motionManager.stopAccelerometerUpdates()
        }
        .alert("Photo Captured", isPresented: $coordinator.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Face captured successfully!")
        }
        .alert("Error", isPresented: $coordinator.showErrorAlert) {
            Button("OK") { }
        } message: {
            Text(coordinator.errorMessage)
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


#Preview {
    DotView()
}
