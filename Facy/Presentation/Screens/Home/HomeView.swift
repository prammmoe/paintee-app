//
//  HomeDesignColletion.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Choose your face painting design")
                    .font(.headline)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 150)), count: 2), spacing: 14) {
                ForEach(0..<10) { index in
                    // Hanya card pertama (index 0) yang memiliki star dan navigasi
                    if index == 0 {
                        NavigationLink(destination: PreviewView()) {
                            DesignCard(hasStarImage: true)
                        }
                        .buttonStyle(PlainButtonStyle()) // Menghilangkan efek button default
                    } else {
                        DesignCard(hasStarImage: false)
                    }
                }
            }
            .padding(10)
        }
        .navigationTitle(Text("Design"))
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DesignCard: View {
    let hasStarImage: Bool
    
    var body: some View {
        VStack {
            // Oval placeholder untuk wajah
            Ellipse()
                .fill(Color(.systemGray5))
                .frame(width: 60, height: 80)
                .overlay(
                    Ellipse()
                        .stroke(Color(.systemGray4), lineWidth: 1.5)
                )
                .overlay(
                    // Menampilkan star.png hanya jika hasStarImage true
                    Group {
                        if hasStarImage {
                            Image("star")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        }
                    }
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(hasStarImage ? Color.blue : Color(.systemGray4), lineWidth: 2)
        )
    }
}

//
//// Halaman preview AR yang akan dituju ketika card dengan star ditekan
//struct DesignDetailView: View {
//    @Environment(\.dismiss) private var dismiss
//    @State private var showTutorial = true
//    
//    var body: some View {
//        ZStack {
//            // AR View Container sebagai background
//            ARViewContainer()
//                .edgesIgnoringSafeArea(.all)
//                .blur(radius: showTutorial ? 10 : 0)
//                .animation(.easeInOut(duration: 0.3), value: showTutorial)
//            
//            // Overlay controls di atas AR view
//            VStack {
//                Spacer()
//                
//                // Bottom control panel
//                VStack(spacing: 12) {
//                    NavigationLink(destination: FaceDetectionView()) {
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
//            // Additional cleanup when view disappears
//            // The ARViewContainer's dismantleUIView will handle the main cleanup
//        }
//        .sheet(isPresented: $showTutorial) {
//            TutorialSheetView()
//        }
//    }
//}

#Preview {
    HomeView()
}
