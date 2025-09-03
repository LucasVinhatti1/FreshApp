
import SwiftUI

struct PhotoResultView: View {
    let image: UIImage
    let message: String
    var onClose: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    private var isRotten: Bool {
        let m = message.lowercased()
        return m.contains("rotten")
    }
    private var accent: Color { isRotten ? .red : .green }

    private func close() {
        dismiss()
        onClose()
    }

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Button(action: close) {
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                        .shadow(radius: 4)
                }
                Text("Back")
                    .foregroundStyle(.white)
                    .font(.custom("Arial", size: 28))
                    .shadow(radius: 4)
            }
            .offset(x: 0, y: 670)
        }
    
        .safeAreaInset(edge: .bottom) {
            ZStack(alignment: .bottom) {
                Text(message)
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundColor(accent)
                    .padding(.bottom, 12)
            }
            
            .offset(x: 0, y: -100)
            
        }
        
    }
    
    
}
