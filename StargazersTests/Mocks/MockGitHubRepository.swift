//
//  MockGitHubRepository.swift
//  StargazersTests
//
//  Created by Davide Mazzoni on 15/12/20.
//

import Combine
import Foundation
import XCTest

@testable import Stargazers

// MARK: - MockGitHubRepository
final class MockGitHubRepository {
    
    var onFetchStargazers: ((ListStargazersRequest) -> AnyPublisher<[Stargazer], Error>)?
}

// MARK: - GitHubRepositoryConformance
extension MockGitHubRepository: GitHubRepository {
    
    func fetchStargazers(request: ListStargazersRequest) -> AnyPublisher<[Stargazer], Error> {
        
        guard let implementation = self.onFetchStargazers else {
            fatalError("No mock implementation provided for fetchStargazers method")
        }
        
        return implementation(request)
    }
}
