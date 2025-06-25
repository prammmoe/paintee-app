//
//  TakePictureView.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import AVFoundation

struct CameraSnapView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraViewModel = CameraViewModel()
    @State private var showPreview = false

    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview(session: cameraViewModel.session)
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    Button(action: {
                        cameraViewModel.takePhoto()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 80, height: 80)

                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                                .frame(width: 65, height: 65)
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Snap Your Results")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Home") {
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            .onAppear {
                cameraViewModel.configureCamera()
            }
            .onChange(of: cameraViewModel.capturedImage) {
                if cameraViewModel.capturedImage != nil {
                    showPreview = true
                }
            }
//            .navigationDestination(isPresented: $showPreview) {
//                if let img = cameraViewModel.capturedImage {
//                    PreviewCapture(image: img, capturedImage: $cameraViewModel.capturedImage)
//                } else {
//                    EmptyView()
//                }
//            }
            .navigationDestination(isPresented: Binding(
                            get: { cameraViewModel.capturedImage != nil },
                            set: { isPresented in
                                if !isPresented {
                                    cameraViewModel.capturedImage = nil
                                }
                            }
                        )) {
                            if let image = cameraViewModel.capturedImage {
                                PreviewCapture(image: image, capturedImage: $cameraViewModel.capturedImage)
                            } else {
                                EmptyView()
                            }
                        }

        }
    }
}




extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.capturedImage = image
            }
        }
    }
}



struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
//        previewLayer.connection?.videoOrientation = .portrait
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

