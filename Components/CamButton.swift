import SwiftUI
import UIKit

struct CamButton<Label: View>: View {
    @Binding var image: UIImage?
    @State private var showCamera = false
    let label: () -> Label

    var body: some View {
        Button(action: { showCamera = true }, label: label)
            .sheet(isPresented: $showCamera) {
                CameraPicker(selectedImage: $image, isPresented: $showCamera)
                    .ignoresSafeArea()
            }
    }
}
