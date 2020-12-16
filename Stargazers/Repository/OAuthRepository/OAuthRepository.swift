//
//  OAuthRepository.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Combine
import Foundation

// MARK: - OAuthRepository
protocol OAuthRepository {
    
    var isLoggedIn: Bool { get }
    
    func login() -> AnyPublisher<OAuthToken, OAuthRepositoryError>
    func logout()
}

// MARK: - OAuthRepositoryError
enum OAuthRepositoryError: Swift.Error {
    case authorizationError(reason: Swift.Error)
    case cancelled
    case codeExchangeError(reason: Swift.Error)
    case invalidAuthorizationURL
    case invalidCallback
    case missingCallbackURL
}
