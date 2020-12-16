//
//  OAuthConfiguration.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation

// MARK: - OAuthConfiguration
struct OAuthConfiguration {
    
    let clientId: String
    let clientSecret: String
    let callbackScheme: String
    let callbackUrl: String
}

// MARK: - API
extension OAuthConfiguration {
    
    var callbackUrlComponents: URLComponents? {
        URLComponents(string: self.callbackUrl)
    }
}
