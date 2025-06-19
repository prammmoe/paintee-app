//
//  FacePaintingViewContainer.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI
import ARKit
import RealityKit

class FacePaintingView: ARView {
    
    private let facePaintManager = FacePaintManager()
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        // you could also defer .becomeFirstResponder() here
        facePaintManager.start(on: self)
    }
    
    @available(*, unavailable)
    required init?(coder Decoder: NSCoder) { fatalError("Not supported") }
    
    override var canBecomeFirstResponder: Bool { true }
}

struct PreviewView: UIViewRepresentable {
    func makeUIView(context: Context) -> FacePaintingView {
        FacePaintingView(frame: .infinite)
    }
    func updateUIView(_ uiView: FacePaintingView, context: Context) {
        // TODO: Implement update UI lifecycle
    }
}


