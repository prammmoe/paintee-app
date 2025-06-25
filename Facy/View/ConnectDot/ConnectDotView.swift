//
//  ConnectDotView.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ConnectDotView: View {
    @Environment(\.dismiss) private var dismiss
    let asset: FacePaintingAsset
    
    @EnvironmentObject private var router: Router

    var body: some View {
        ZStack {
            ConnectDotARViewContainer(asset: asset)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Button {
                        router.navigate(to: .drawingview(asset: asset))
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
        .navigationTitle("Continue")
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

struct ConnectDotARViewContainer: UIViewRepresentable {
    let asset: FacePaintingAsset
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(asset: asset, assetType: .preview) 
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

