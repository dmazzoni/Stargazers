//
//  ClearButton.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import SwiftUI

// MARK: - ClearButton
struct ClearButton: ViewModifier {
    
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            content
            if !text.isEmpty {
                clearButton
            }
        }
    }
}

// MARK: - Convenience
extension View {
    
    func clearButton(text: Binding<String>) -> some View {
        self.modifier(ClearButton(text: text))
    }
}

// MARK: - Private
private extension ClearButton {
    
    var clearButton: some View {
        Button(
            action: {
                self.text = ""
            },
            label: {
                Image(systemName: "clear")
                    .foregroundColor(Color(.darkGray))
            }
        )
    }
}
