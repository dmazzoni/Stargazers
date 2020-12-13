//
//  User.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation

// MARK: - User
struct User: Decodable {
    
    let login: String
    let avatarUrl: URL?
}
