//
//  RepositoryFormView.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 14/12/20.
//

import SwiftUI

// MARK: - RepositoryFormView
struct RepositoryFormView: View {
    
    @Binding var repositoryOwner: String
    @Binding var repositoryName: String
    
    var body: some View {
        
        VStack(spacing: 16) {
            FormTextField(text: $repositoryOwner, icon: Image(systemName: "person"), placeholder: "Owner")
                .accessibility(identifier: StargazerListAxIdentifiers.repositoryOwner.rawValue)
            FormTextField(text: $repositoryName, icon: Image(systemName: "externaldrive.connected.to.line.below"), placeholder: "Name")
                .accessibility(identifier: StargazerListAxIdentifiers.repositoryName.rawValue)
        }
        .padding(.vertical, 16)
    }
}
