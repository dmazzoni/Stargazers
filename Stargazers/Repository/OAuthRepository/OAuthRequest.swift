//
//  OAuthRequest.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation

// MARK: - OAuthRequest
protocol OAuthRequest {
    var baseURL: URL { get }
}

// MARK: - Default base URL
extension OAuthRequest {
    
    var baseURL: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://github.com/")!
    }
}
