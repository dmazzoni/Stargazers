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
            repositoryForm
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
    
    var repositoryForm: some View {
        
        VStack(spacing: 16) {
            FormTextField(text: $viewModel.repositoryOwner, icon: Image(systemName: "person"), placeholder: "Owner")
            FormTextField(text: $viewModel.repositoryName, icon: Image(systemName: "externaldrive.connected.to.line.below"), placeholder: "Name")
            searchButton
        }
        .padding(.top, 16)
    }
    
    var searchButton: some View {
        
        Button("Search") {
            self.hideKeyboard()
            self.viewModel.didRequestStargazerUpdate()
        }
        .disabled(viewModel.isSearchDisabled)
    }
    
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
