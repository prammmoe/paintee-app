//
//  DrawingView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 24/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct DrawingView: View {
    @Environment(\.dismiss) private var dismiss
    let previewImage: String

    var body: some View {
        ZStack {
            DrawingARViewContainer(previewImage: previewImage)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        Text("Continue with this design")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
        }
        .navigationTitle("Star Design Preview")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
                .fontWeight(.semibold)
            }
        }
        .onDisappear {
            // TODO: State handling when view dismantled
        }
    }
}

struct DrawingARViewContainer: UIViewRepresentable {
    let previewImage: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(previewImage: previewImage) // Without VM
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        if let customView = uiView as? ARViewController {
            customView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
}
