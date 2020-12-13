//
//  StargazersApp.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import SwiftUI

@main
struct StargazersApp: App {
    var body: some Scene {
        WindowGroup {
            StargazerListView(viewModel: .init())
        }
    }
}
