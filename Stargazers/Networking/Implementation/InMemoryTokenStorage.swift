//
//  InMemoryTokenStorage.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation

// MARK: - InMemoryTokenStorage
final class InMemoryTokenStorage {
    
    var authToken: OAuthToken?
}

// MARK: - ApiAuthorizationProvider
extension InMemoryTokenStorage: ApiAuthorizationProvider {
    
    var authorizationHeader: String? {
        
        guard let token = self.authToken else {
            return nil
        }
        
        return "token \(token.value)"
    }
}
