//
//  CameraViewModel.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 25/06/25.
//

import SwiftUI
import AVFoundation

class CameraViewModel: NSObject, ObservableObject {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    @Published var capturedImage: UIImage? = nil
    @Published var isSessionRunning = false
    @Published var permissionDenied = false
    
    private var isConfigured = false

    override init() {
        super.init()
        output.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])])
    }

    func configureCamera() {
        guard !isConfigured else {
            if !session.isRunning {
                DispatchQueue.global(qos: .userInitiated).async {
                    self.session.startRunning()
                    DispatchQueue.main.async {
                        self.isSessionRunning = self.session.isRunning
                    }
                }
            }
            return
        }
        checkCameraPermission()
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.setupCamera()
                    } else {
                        self.permissionDenied = true
                        print("Camera permission denied")
                    }
                }
            }
        case .denied, .restricted:
            DispatchQueue.main.async {
                            self.permissionDenied = true
                        }
        @unknown default:
            print("Unknown camera authorization status")
        }
    }
    
    private func setupCamera() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        session.inputs.forEach { session.removeInput($0) }
        session.outputs.forEach { session.removeOutput($0) }

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get front camera")
            session.commitConfiguration()
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Cannot add camera input")
                session.commitConfiguration()
                return
            }
        } catch {
            print("Error creating camera input: \(error)")
            session.commitConfiguration()
            return
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            print("Cannot add photo output")
            session.commitConfiguration()
            return
        }

        session.commitConfiguration()
        isConfigured = true

        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
            DispatchQueue.main.async {
                self.isSessionRunning = self.session.isRunning
                print("Camera session started: \(self.isSessionRunning)")
            }
        }
    }

    func takePhoto() {
        guard session.isRunning else {
            print("Camera session is not running")
            return
        }
        // Haptic Feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    deinit {
        session.stopRunning()
    }
}

extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("Photo capture error: \(error)")
            return
        }
        
        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.capturedImage = image
                print("Photo captured successfully")
            }
        }
    }
}
