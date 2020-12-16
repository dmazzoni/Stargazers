//
//  MockOAuthRepository.swift
//  StargazersTests
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Combine
import Foundation
import XCTest

@testable import Stargazers

// MARK: - MockOAuthRepository
final class MockOAuthRepository {
    
    private var token: OAuthToken?
}

// MARK: - OAuthRepositoryConformance
extension MockOAuthRepository: OAuthRepository {
    
    var isLoggedIn: Bool {
        self.token != nil
    }
    
    func login() -> AnyPublisher<OAuthToken, OAuthRepositoryError> {
        
        let token = self.defaultToken
        self.token = token
        return Result.success(token).publisher.eraseToAnyPublisher()
    }
    
    func logout() {
        self.token = nil
    }
}

// MARK: - Private
private extension MockOAuthRepository {
    
    var defaultToken: OAuthToken {
        OAuthToken(tokenType: "bearer", value: "test_token")
    }
}
