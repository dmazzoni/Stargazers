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
        Text(stargazer.user.login)
    }
}
