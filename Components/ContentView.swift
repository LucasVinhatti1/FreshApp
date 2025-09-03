import SwiftUI
import UIKit

struct ResultPayload: Identifiable {
    let id = UUID()
    var image: UIImage
    var message: String
}

struct HomePageView: View {
    @State private var openInfo = false
    @State private var capturedImage: UIImage?
    @State private var result: ResultPayload?
    @State private var dropLanded = false
    @State private var dropSquish = false
    
    
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing: 6) {
                    Text("Freshly")
                        .font(.system(size: 80, weight: .heavy, design: .none))
                        .foregroundStyle(.white)
                    
                    Image(systemName: "drop")
                        .padding(-10)
                        .font(.title)
                        .foregroundStyle(.white)
                        .shadow(color: .white.opacity(0.2), radius: 3, x: 0, y: 1)
                        .fallAndSquish()
                }
                .offset(x: 0, y: -120)
                
                Text("Freshness and trust at your fingertips")
                    .font(.custom("Arial", size: 15))
                    .foregroundStyle(.white)
                    .offset(x:0, y:-120)
                
                if let img = capturedImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.5), lineWidth: 1))
                        .padding(.top, 16)
                        .shadow(radius: 6)
                }
                
                CamButton(image: $capturedImage) {
                    Image(systemName: "camera.circle.fill")
                        .font(.system(size: 100, weight: .bold))
                        .foregroundStyle(.white, .opacity(sin(3)))
                }
                .offset(x:0, y:100)
                
                HStack {
                    Button { openInfo = true } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 25))
                            .foregroundStyle(.white, .opacity(sin(3)))
                            .frame(width: 50)
                        Spacer()
                    }
                }
                .offset(x:-1,y:260)
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .green, location: 0.0),
                    .init(color: .yellow, location: 0.6),
                    .init(color: .red, location: 1.0)
                ]),
                startPoint: .topTrailing,
                endPoint: .bottomTrailing
            )
        )
        .infoAlert(isPresented: $openInfo)
        .onChange(of: capturedImage) { _, newImage in
            guard let img = newImage else { return }
            
            Task {
                var text: String
                if let model = ProduceClassifier.shared {
                    do {
                        let pred = try await model.classify(img)
                        let p = pred.parsed
                        text = "This \(p.fruit) is \(p.freshness)"
                        
                    } catch {
                        text = "Couldn’t classify"
                    }
                } else {
                    text = "Model not loaded"
    
                }
                
                await MainActor.run {
                    self.result = ResultPayload(image: img, message: text)
                }
            }
        }
        .fullScreenCover(item: $result) { payload in
            PhotoResultView(image: payload.image, message: payload.message) {
                result = nil
                capturedImage = nil
            }
        }
    }
}

#Preview {
    HomePageView()
}
