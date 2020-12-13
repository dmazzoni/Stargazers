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
            FormTextField(text: $viewModel.repositoryOwner, icon: Image(systemName: "person"), placeholder: "Owner")
            FormTextField(text: $viewModel.repositoryName, icon: Image(systemName: "externaldrive.connected.to.line.below"), placeholder: "Name")
            Button("Search", action: viewModel.didRequestStargazerUpdate)
                .disabled(viewModel.isSearchDisabled)
            Divider()
            if viewModel.showListPlaceholder {
                listPlaceholder
            } else {
                listView
            }
        }
        .alert(item: $viewModel.errorModel) { model in
            Alert(
                title: Text("Error"),
                message: Text(model.message)
            )
        }
    }
}

// MARK: - Private
private extension StargazerListView {
    
    var listView: some View {
        InfiniteList(items: $viewModel.stargazers, isLoading: $viewModel.isLoading) { item in
            StargazerRow(stargazer: item)
        }
        .onScrollToBottom(perform: viewModel.didRequestNextPage)
    }
    
    var listPlaceholder: some View {
        Group {
            Spacer()
            Text("EmptyList")
            Spacer()
        }
    }
}

// MARK: - Previews
struct StargazerListView_Previews: PreviewProvider {
    
    static var previews: some View {
        StargazerListView(viewModel: .init())
    }
}
