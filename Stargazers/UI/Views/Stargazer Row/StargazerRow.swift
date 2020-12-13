//
//  StargazerRow.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import SwiftUI

// MARK: - StargazerRow
struct StargazerRow: View {
    
    var stargazer: Stargazer
    
    var body: some View {
        HStack(spacing: 16) {
            avatarView
                .frame(idealHeight: 60)
                .cornerRadius(30)
            Text(stargazer.user.login)
        }
    }
}

// MARK: - Private
private extension StargazerRow {
    
    var avatarView: some View {
        Group {
            if let avatarUrl = stargazer.user.avatarUrl {
                RemoteImage(url: avatarUrl)
            } else {
                avatarPlaceholder
            }
        }
    }
    
    var avatarPlaceholder: some View {
        Image(systemName: "person.crop.circle")
    }
}
