//
//  StargazerListView.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import SwiftUI

// MARK: - StargazerListView
struct StargazerListView: View {
    
    @ObservedObject var viewModel: StargazerListViewModel
    
    var body: some View {
        VStack {
            IconTextField(text: $viewModel.repositoryOwner, icon: Image(systemName: "person"), placeholder: "Owner")
            IconTextField(text: $viewModel.repositoryName, icon: Image(systemName: "externaldrive.connected.to.line.below"), placeholder: "Name")
            Button("Search", action: viewModel.didRequestStargazerUpdate)
                .disabled(viewModel.isSearchDisabled)
            Divider()
            InfiniteList(items: $viewModel.stargazers, isLoading: $viewModel.isLoading) { item in
                StargazerRow(stargazer: item)
            }
            .onScrollToBottom(perform: viewModel.didRequestNextPage)
        }
        .alert(item: $viewModel.errorModel) { model in
            Alert(
                title: Text("Error"),
                message: Text(model.message)
            )
        }
    }
}

// MARK: - Previews
struct StargazerListView_Previews: PreviewProvider {
    
    static var previews: some View {
        StargazerListView(viewModel: .init())
    }
}
