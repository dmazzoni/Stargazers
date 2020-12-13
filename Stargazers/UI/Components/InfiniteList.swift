//
//  InfiniteList.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import SwiftUI

// MARK: - InfiniteList
struct InfiniteList<Item: Identifiable, RowContent: View>: View {
    
    @Binding var items: [Item]
    @Binding var isLoading: Bool
    
    let rowBuilder: ((Item) -> RowContent)
    
    private(set) var didScrollToBottom: (() -> Void)?
    
    var body: some View {
        Group {
            if isLoading && items.isEmpty {
                Spacer()
                progressView
                Spacer()
            } else {
                List {
                    itemRows
                    if isLoading {
                        progressView
                    }
                }
            }
        }
    }
}

// MARK: - API
extension InfiniteList {
    
    func onScrollToBottom(perform action: @escaping () -> Void) -> Self {
        var view = self
        view.didScrollToBottom = action
        return view
    }
}

// MARK: - Private
private extension InfiniteList {
    
    var progressView: some View {
        ProgressView()
    }
    
    var itemRows: some View {
        
        ForEach(items) { item in
            rowBuilder(item)
                .onAppear {
                    if items.last?.id == item.id {
                        didScrollToBottom?()
                    }
                }
        }
    }
}
