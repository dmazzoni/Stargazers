//
//  ApiEnvironment.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation

// MARK: - ApiEnvironment
struct ApiEnvironment {
    let baseURL: URL
}

// MARK: - ApiRequest convenience
extension ApiRequest {
    
    var baseURL: URL {
        Injector.shared.resolve(ApiEnvironment.self).baseURL
    }
}
