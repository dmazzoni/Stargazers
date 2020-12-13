//
//  LeftImage.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import SwiftUI

// MARK: - LeftImage
struct LeftImage: ViewModifier {
    
    var image: Image
    
    func body(content: Content) -> some View {
        
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            image
            content
        }
    }
}

// MARK: - Convenience
extension View {
    
    func leftImage(_ image: Image) -> some View {
        self.modifier(LeftImage(image: image))
    }
}
