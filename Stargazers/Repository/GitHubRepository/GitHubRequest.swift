//
//  GitHubRequest.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 13/12/20.
//

import Foundation

// MARK: - GitHubRequest
protocol GitHubRequest {
    var baseURL: URL { get }
}

// MARK: - Default base URL
extension GitHubRequest {
    
    var baseURL: URL {
        // swiftlint:disable:next force_unwrapping
        URL(string: "https://api.github.com")!
    }
}
