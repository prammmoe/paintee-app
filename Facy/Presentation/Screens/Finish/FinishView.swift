////
////  FinishView.swift
////  Facy
////
////  Created by Abdul Jabbar on 22/06/25.
////
//
//import SwiftUI
//import AVFoundation
//
//struct FacePaintingFinalView: View {
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                // Live Camera Preview
//                CameraPreview()
//                    .ignoresSafeArea()
//
//                // Top UI (title + instruction)
//                VStack(spacing: 8) {
//                    Spacer().frame(height: 60)
//
//                    Text("Enjoy Painting!")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(Color(red: 47/255, green: 61/255, blue: 113/255))
//
//                    Text("Finish to the fully design")
//                        .font(.system(size: 14, weight: .medium))
//                        .padding(.vertical, 6)
//                        .padding(.horizontal, 12)
//                        .background(Color.yellow)
//                        .cornerRadius(6)
//                        .foregroundColor(.black)
//
//                    Spacer()
//                }
//
//                // Bottom Buttons
//                VStack {
//                    Spacer()
//                    HStack(spacing: 16) {
//                        Button(action: {
//                            // Take photo action
//                        }) {
//                            Label("Take Photo", systemImage: "camera")
//                        }
//                        .buttonStyle(.bordered)
//                        .tint(.blue)
//
//                        Button("Finish") {
//                            // Finish or back to home
//                        }
//                        .buttonStyle(.borderedProminent)
//                        .tint(.blue)
//                    }
//                    .padding(.horizontal, 24)
//                    .padding(.bottom, 34)
//                }
//            }
//            .navigationTitle("")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    // System back button is already available in NavigationStack
//                    EmptyView()
//                }
//            }
//        }
//    }
//}
//#Preview {
//}
