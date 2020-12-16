//
//  AccessTokenRequest.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation

// MARK: - AccessTokenRequest
struct AccessTokenRequest: OAuthRequest {
    
    let clientId: String
    let clientSecret: String
    let code: String
    
    init(
        oauthConfiguration: OAuthConfiguration,
        code: String
    ) {
        self.code = code
        self.clientId = oauthConfiguration.clientId
        self.clientSecret = oauthConfiguration.clientSecret
    }
}

// MARK: - ApiRequest conformance
extension AccessTokenRequest: ApiRequest {
    
    typealias Response = AccessTokenResponse
    
    var method: ApiMethod { .post }
    
    var headers: [String: String] {
        [
            "Accept": "application/json"
        ]
    }
    
    var urlComponents: URLComponents? {
        
        guard var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        urlComponents.path = "/login/oauth/access_token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: self.clientId),
            URLQueryItem(name: "client_secret", value: self.clientSecret),
            URLQueryItem(name: "code", value: self.code)
        ]
        
        return urlComponents
    }
}

// MARK: - AccessTokenResponse
struct AccessTokenResponse: Decodable {
    
    let accessToken: String
    let tokenType: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
