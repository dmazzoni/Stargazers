//
//  FormTextField.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import SwiftUI

// MARK: - FormTextField
struct FormTextField: View {
    
    @Binding var text: String
    
    var icon: Image
    var placeholder: LocalizedStringKey
    
    var body: some View {
        
        TextField(placeholder, text: $text)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .leftImage(icon)
            .clearButton(text: $text)
            .padding(.horizontal)
    }
}

// MARK: - Previews
struct FormTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        FormTextField(text: .constant("test"), icon: Image(systemName: "person"), placeholder: "Placeholder")
        
        FormTextField(text: .constant(""), icon: Image(systemName: "person.fill"), placeholder: "Placeholder")
    }
}
