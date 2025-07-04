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
    @StateObject private var sessionManager = ARFaceSessionManager.shared
    @EnvironmentObject private var router: Router
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CameraPreview(session: cameraViewModel.session)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
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
        }
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.goBack()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .accessibilityLabel("3. Back")
                    .accessibilityIdentifier("CameraBackButton")
                    .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Snap Your Results")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Home") {
                    router.reset()
                }
                .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color.pBlue.opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            print("CameraSnapView appeared - configuring camera")
            cameraViewModel.configureCamera()
        }
        .onDisappear {
            print("CameraSnapView disappeared - stopping camera session")
            cameraViewModel.session.stopRunning()
        }
        .onChange(of: cameraViewModel.capturedImage) {
            if cameraViewModel.capturedImage != nil {
                showPreview = true
            }
        }
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
        .onChange(of: router.currentRoute) { oldRoute, newRoute in
            if newRoute == .homeview {
                sessionManager.stopSession()
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        // Store the preview layer for later access
        view.tag = 999
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the preview layer frame when the view bounds change
        DispatchQueue.main.async {
            if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
                previewLayer.frame = uiView.bounds
            }
        }
    }
}

// Alternative CameraPreview implementation that's more reliable
struct CameraPreviewAlternative: UIViewRepresentable {
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> CameraPreviewUIView {
        return CameraPreviewUIView(session: session)
    }
    
    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        // No need to update anything here as the custom view handles it
    }
}

class CameraPreviewUIView: UIView {
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    init(session: AVCaptureSession) {
        super.init(frame: .zero)
        setupPreviewLayer(session: session)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPreviewLayer(session: AVCaptureSession) {
        backgroundColor = .black
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        
        if let previewLayer = previewLayer {
            layer.addSublayer(previewLayer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}


