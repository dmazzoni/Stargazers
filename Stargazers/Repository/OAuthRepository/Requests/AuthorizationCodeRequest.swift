//
//  AuthorizationCodeRequest.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation

// MARK: - AuthorizationCodeRequest
struct AuthorizationCodeRequest: OAuthRequest {
    
    let clientId: String
    let redirectUri: String
    
    init(
        oauthConfiguration: OAuthConfiguration
    ) {
        self.clientId = oauthConfiguration.clientId
        self.redirectUri = oauthConfiguration.callbackUrl
    }
}

// MARK: - ApiRequest conformance
extension AuthorizationCodeRequest: ApiRequest {
    
    typealias Response = URL
    
    var method: ApiMethod { .get }
    
    var urlComponents: URLComponents? {
        
        guard var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        urlComponents.path = "/login/oauth/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "redirect_uri", value: self.redirectUri)
        ]
        
        return urlComponents
    }
}
