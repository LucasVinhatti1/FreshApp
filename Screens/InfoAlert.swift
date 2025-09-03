//
//  InfoAlert.swift
//  FreshApp
//
//  Created by aluno-05 on 28/08/25.
//

import SwiftUI

struct InfoAlert: ViewModifier {
    
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content.alert("Information", isPresented: $isPresented) {
            Button("Close", role: .cancel) { }
        } message: {
            Text("This app does not contain all fruits and vegetables")
        }
    }
    
}

extension View {
    func infoAlert(isPresented: Binding<Bool>) -> some View {
        self.modifier(InfoAlert(isPresented: isPresented))
    }
}

