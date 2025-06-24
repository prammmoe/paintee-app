//
//  FacePaintingViewContainer.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

//import SwiftUI
//import ARKit
//import RealityKit
//
//struct PreviewView: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var showTutorial = true
//    @State private var isARActive: Bool = true
//
//    let previewImage: String
//
//    var body: some View {
////        ZStack {
////            // ARView using Reality
////            PreviewARViewContainer(previewImage: previewImage)
////                .edgesIgnoringSafeArea(.all)
////            
////            VStack {
////                Spacer()
////                
////                VStack(spacing: 12) {
////                    NavigationLink(destination: DotView(previewImage: previewImage)) {
////                        Text("Continue with this design")
////                            .font(.system(size: 17, weight: .semibold))
////                            .foregroundColor(.white)
////                            .frame(maxWidth: .infinity)
////                            .frame(height: 50)
////                            .background(Color.blue)
////                            .cornerRadius(10)
////                    }
////                    .disabled(showTutorial)
////                    .opacity(showTutorial ? 0.5 : 1.0)
////                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
////                }
////                .padding(.horizontal, 20)
////                .padding(.bottom, 34)
////            }
////        }
//        ZStack {
//            // ARView
//            if isARActive {
//                PreviewARViewContainer(previewImage: previewImage)
//                    .edgesIgnoringSafeArea(.all)
//            } else {
//                Color.black.edgesIgnoringSafeArea(.all)
//                Image(previewImage)
//                    .resizable()
//                    .scaledToFit()
//                    .padding()
//            }
//
//            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        isARActive.toggle()
//                    }) {
//                        Image(systemName: isARActive ? "arkit" : "arkit.badge.xmark")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding(12)
//                            .background(Color.black.opacity(0.5))
//                            .clipShape(Circle())
//                    }
//                    .padding(.top, 16)
//                    .padding(.trailing, 20)
//                }
//                Spacer()
//                
//                VStack(spacing: 12) {
//                    NavigationLink(destination: DotView(previewImage: previewImage)) {
//                        Text("Continue with this design")
//                            .font(.system(size: 17, weight: .semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                    .disabled(showTutorial)
//                    .opacity(showTutorial ? 0.5 : 1.0)
//                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 30) // dinaikkan sedikit
//            }
//        }
//        .navigationTitle("Star Design Preview")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(false)
//        .onDisappear {
//            isARActive = false
//        }
//        .sheet(isPresented: $showTutorial) {
//            TutorialSheetView()
//        }
//
//        .navigationTitle("Star Design Preview")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(false)
//        .onDisappear {
//            isARActive = false
//        }
//        .sheet(isPresented: $showTutorial) {
//            TutorialSheetView()
//        }
//
//        .navigationTitle("Star Design Preview")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(false)
//        .onDisappear {
////            isARActive = false // <--- Ini akan trigger ARViewContainer untuk stop session
//        }
//        .sheet(isPresented: $showTutorial) {
//            TutorialSheetView()
//        }
//    }
//}

import SwiftUI
import ARKit
import RealityKit

struct PreviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showTutorial = true
    @State private var showPreviewImage = true

    let previewImage: String

    var body: some View {
        ZStack {
            // AR View with toggle-able preview overlay
            PreviewARViewContainer(previewImage: previewImage, showPreviewImage: showPreviewImage)
                .edgesIgnoringSafeArea(.all)
            
//            VStack {
//                    Text("The colors shown here are just inspiration.\nFeel free to use your own colors.")
//                        .font(.subheadline)
//                        .foregroundColor(.black)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 10)
//                        .background(Color.orange)
//                        .cornerRadius(12)
//                        .padding(.top, 100)
//
//                    Spacer()
//                }
//                .ignoresSafeArea(edges: .top)

            VStack {
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        showPreviewImage.toggle()
//                    }) {
//                        Image(systemName: "sparkles")
//                            .font(.title2)
//                            .foregroundColor(showPreviewImage ? Color.yellow : .white)
//                            .padding(12)
//                            .background(Color.black.opacity(0.5))
//                            .clipShape(Circle())
//                    }
//                    .padding(.top, 16)
//                    .padding(.trailing, 20)
//                }

                Spacer()

                VStack(spacing: 12) {
                    NavigationLink(destination: DotView(previewImage: previewImage)) {
                        Text("Continue with this design")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("dark-blue"))
                            .cornerRadius(15)
                    }
                    .disabled(showTutorial)
                    .opacity(showTutorial ? 0.5 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: showTutorial)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
//        .navigationTitle("Design Preview")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Design Preview")
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
        .sheet(isPresented: $showTutorial) {
            TutorialSheetView()
        }
    }
}


struct TutorialSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            // Handle indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.secondary)
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Preview your selected face painting guide")
                    .font(.title2)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("You can continue or try different design.\nThe colors shown are just inspiration, feel free to get creative!")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("Okay")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 34)
        }
        .background(Color(.systemBackground))
        .presentationDetents([.fraction(0.50)])
        .presentationDragIndicator(.hidden)
    }
}

//struct PreviewARViewContainer: UIViewRepresentable {
//    let previewImage: String
//    
//    func makeUIView(context: Context) -> ARView {
//        let arView = ARViewController(frame: .zero)
//        arView.setup(previewImage: previewImage) // Without VM
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARView, context: Context) {}
//    
//    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
//        if let customView = uiView as? ARViewController {
//            customView.stopSession()
//        } else {
//            uiView.session.pause()
//        }
//    }
//}
struct PreviewARViewContainer: UIViewRepresentable {
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



