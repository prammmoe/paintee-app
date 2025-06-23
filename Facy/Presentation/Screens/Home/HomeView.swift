//
//  HomeDesignColletion.swift
//  Facy
//
//  Created by Pramuditha Muhammad Ikhwan on 16/06/25.


import SwiftUI

struct HomeView: View {
    let images = ["design1", "design2", "design3", "design4"]
    func getLabel(for imageName: String) -> String {
        switch imageName {
        case "design1": return "Tribal"
        case "design2": return "Clown"
        case "design3": return "Fox"
        case "design4": return "Super hero"
        default: return ""
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 34/255, green: 40/255, blue: 80/255), Color(red: 10/255, green: 20/255, blue: 50/255)]),
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 5) {
                    // Title
                    Text("Face Painting Design Collection")
                        .font(.system(size: 36, weight: .heavy))
                        .foregroundColor(Color.orange)
                        .padding(.top, 70)
                        .padding(.horizontal, 15)

                    // Subtitle
                    Text("Choose our creative and easy-to-draw face painting design collection.")
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.white)
                        .padding([.top, .horizontal])
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 1)

                    // Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(images, id: \.self) { image in
                            NavigationLink(destination: DotView()) {
                                ZStack(alignment: .bottom) {
                                    Color.cream
                                        .cornerRadius(25)

                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 126, height: 161)
                                        .padding(.bottom,15)

                                    // Label oren
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.orange)
                                        .frame(width: 135, height: 30)
                                        .overlay(
                                            Text(getLabel(for: image))
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .padding(.trailing)
                                }
                                .frame(width: 152, height: 184)
                                .shadow(radius: 5)
                                .padding(5)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 25)

                    Spacer()
                }
                .padding(.horizontal, 15)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
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

