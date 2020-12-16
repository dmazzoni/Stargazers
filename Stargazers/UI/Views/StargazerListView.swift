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
            HStack {
                Spacer()
                loginButton
            }
            .padding([.horizontal, .top])
            RepositoryFormView(repo: $viewModel.repo)
            searchButton
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
    
    var searchButton: some View {
        
        Button("Search") {
            self.hideKeyboard()
            self.viewModel.didRequestStargazerUpdate()
        }
        .disabled(viewModel.isSearchDisabled)
        .accessibility(identifier: StargazerListAxIdentifiers.searchButton.rawValue)
    }
    
    var loginButton: some View {
        
        Button(LocalizedStringKey(viewModel.loginButtonTitle)) {
            self.hideKeyboard()
            self.viewModel.didTapLoginButton()
        }
        .disabled(viewModel.isLoginDisabled)
        .accessibility(identifier: StargazerListAxIdentifiers.loginButton.rawValue)
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
        StargazerListView(
            viewModel: Injector.shared.resolve(StargazerListViewModel.self)
        )
    }
}
