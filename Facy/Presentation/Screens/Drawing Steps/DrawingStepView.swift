import SwiftUI

struct DrawingStepsView: View {
    // Define grid layout with two flexible columns
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Title
                Text("Drawing Steps")
                    .font(.system(size: 36, weight: .heavy))
                    .foregroundColor(Color(red: 47/255, green: 61/255, blue: 113/255))
                    .padding(.top, 40)
                Spacer()

                // Grid of steps
                LazyVGrid(columns: columns, spacing: 32) {
                    StepItem(imageName: "step1", caption: "Put phone\non steady surface")
                    StepItem(imageName: "step2", caption: "Find proper\nLight")
                    StepItem(imageName: "step3", caption: "Dot your face\nfollowing guide\non screen")
                    StepItem(imageName: "step4", caption: "Start drawing fully\nwith your dots")
                }
                .padding(.horizontal, 24)

                Spacer()
                Spacer()
                Spacer()

                // Continue Button
                Button(action: {
                    // Handle continue action
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 47/255, green: 61/255, blue: 113/255))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 40)
                .padding(.bottom, 34)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 254/255, green: 248/255, blue: 235/255))
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// Grid Item Component
struct StepItem: View {
    let imageName: String
    let caption: String

    var body: some View {
        VStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 125, height: 125)

            Text(caption)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 47/255, green: 61/255, blue: 113/255))
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    DrawingStepsView()
}
