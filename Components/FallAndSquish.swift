import SwiftUI

struct FallAndSquish: ViewModifier {
    
    @Environment(\.scenePhase) private var scenePhase
    //controle fino da animação
    private let fallDuration: Double = 1.8
    private let fallBounce: Double   = 0.15

    @State private var landed = false
    @State private var squish = false

    func body(content: Content) -> some View {
        content
            .offset(y: landed ? 0 : -240)
            .scaleEffect(x: 1, y: squish ? 0.75 : 1, anchor: .bottom)
            .animation(.spring(duration: fallDuration, bounce: fallBounce), value: landed)
            .animation(.easeOut(duration: 0.12), value: squish)
            .onAppear { start() }
    }

    private func start() {
        landed = false
        squish = false
        DispatchQueue.main.async {
            landed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + fallDuration) {
                squish = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
                    squish = false
                }
            }
        }
    }
}

extension View { func fallAndSquish() -> some View { modifier(FallAndSquish()) } }
