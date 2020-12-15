//
//  RepositoryFormView.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 14/12/20.
//

import SwiftUI

// MARK: - RepositoryFormView
struct RepositoryFormView: View {
    
    @Binding var repo: Repo
    
    var body: some View {
        
        VStack(spacing: 16) {
            FormTextField(text: $repo.owner, icon: Image(systemName: "person"), placeholder: "Owner")
                .accessibility(identifier: RepositoryFormAxIdentifiers.owner.rawValue)
            FormTextField(text: $repo.name, icon: Image(systemName: "externaldrive.connected.to.line.below"), placeholder: "Name")
                .accessibility(identifier: RepositoryFormAxIdentifiers.name.rawValue)
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Previews
struct RepositoryFormView_Previews: PreviewProvider {
    
    static var previews: some View {
        RepositoryFormView(repo: .constant(Repo()))
        RepositoryFormView(
            repo: .constant(Repo(owner: "Foo", name: "Bar"))
        )
    }
}
