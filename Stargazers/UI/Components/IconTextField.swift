//
//  IconTextField.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import SwiftUI

// MARK: - IconTextField
struct IconTextField: View {
    
    @Binding var text: String
    
    var icon: Image
    var placeholder: LocalizedStringKey
    
    var body: some View {
        
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            icon
            TextField(placeholder, text: $text)
                .disableAutocorrection(true)
                .autocapitalization(.none)
        }
        .padding()
    }
}

// MARK: - Previews
struct IconTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        IconTextField(text: .constant("test"), icon: Image(systemName: "person"), placeholder: "Placeholder")
    }
}
