//
//  Stargazer.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation

// MARK: - Stargazer
struct Stargazer: Decodable {
    
    let user: User
    let timestamp: Date
}

// MARK: - Identifiable
extension Stargazer: Identifiable {
    
    var id: String { self.user.login }
}
