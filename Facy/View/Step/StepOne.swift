//
//  StepOne.swift
//  Facy
//
//  Created by Shafa Tiara Tsabita Himawan on 25/06/25.
//

import SwiftUI
import ARKit
import RealityKit

struct StepOne: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTutorial = true
    @State private var showPreviewImage = true


    let previewImage: String

    var body: some View {
        ZStack {
            // AR View with toggle-able preview overlay
            DotsARViewContainer(previewImage: previewImage, showPreviewImage: showPreviewImage)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                    Text("Follow the dots and mark your face!")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.orange.opacity(0.5))
                        .cornerRadius(12)
                        .padding(.top, 100)

                    Spacer()
                }
                .ignoresSafeArea(edges: .top)

            VStack {

                Spacer()

                VStack(spacing: 12) {
                    NavigationLink(destination: StepTwo(previewImage: previewImage)) {
                        Text("Continue")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("dark-blue"))
                            .cornerRadius(15)
                    }
//                    .disabled(showTutorial)
//                    .opacity(showTutorial ? 0.5 : 1.0)
//                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
//        .navigationTitle("Design Preview")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Step 1 of 3")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showPreviewImage.toggle()
                            }) {
                                Image(systemName: "sparkles")
                                    .font(.headline)
                                    .foregroundColor(showPreviewImage ? Color.yellow : .white)
                                    .padding(10)
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                        }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
//        .sheet(isPresented: $showTutorial) {
//        }
    }
}



struct DotsARViewContainer: UIViewRepresentable {
    let previewImage: String
    let showPreviewImage: Bool

    func makeUIView(context: Context) -> ARView {
        let arView = ARViewController(frame: .zero)
        arView.setup(previewImage: previewImage)
        arView.setDesignVisible(showPreviewImage)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let arVC = uiView as? ARViewController {
            arVC.setDesignVisible(showPreviewImage)
        }
    }

    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        if let customView = uiView as? ARViewController {
            customView.stopSession()
        } else {
            uiView.session.pause()
        }
    }
}



