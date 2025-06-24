////
////  ConnectDotView.swift
////  Facy
////
////  Created by Pramuditha Muhammad Ikhwan on 23/06/25.
////
//
//import SwiftUI
//import ARKit
//import RealityKit
//
//struct ConnectDotView: View {
//    @Environment(\.dismiss) private var dismiss
////    @State private var isARActive = true  // <--- Tambahkan ini
////    @StateObject private var coordinator = ARFacePaintCoordinator() // Use the new manager
//
//    var body: some View {
//        ZStack {
//            // ARView using Reality
//            ConnectDotARViewContainer()
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Spacer()
//                
//                VStack(spacing: 12) {
//                    NavigationLink(destination: DotView()) {
//                        Text("Continue with this design")
//                            .font(.system(size: 17, weight: .semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 34)
//            }
//        }
//        .navigationTitle("Star Design Preview")
//        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(false)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button("Done") {
//                    dismiss()
//                }
//                .foregroundColor(.white)
//                .fontWeight(.semibold)
//            }
//        }
//        .onDisappear {
//            // TODO: State handling when view dismantled
//        }
//    }
//}
//
//struct ConnectDotARViewContainer: UIViewRepresentable {
//    
//    func makeUIView(context: Context) -> ARViewController {
//        let arView = ARViewController(frame: .zero)
//        arView.setup() // Without VM
//        return arView
//    }
//    
//    func updateUIView(_ uiView: ARViewController, context: Context) {}
//    
//    static func dismantleUIView(_ uiView: ARViewController, coordinator: ()) {
//        uiView.session.pause()
//        uiView.subscription?.cancel()
//        uiView.faceEntity?.removeFromParent()
//    }
//}
//
