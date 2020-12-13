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
            Image(systemName: "person.crop.circle")
            Text(stargazer.user.login)
        }
    }
}
