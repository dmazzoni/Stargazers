//
//  GitHubRepository.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Combine
import Foundation

// MARK: - GitHubRepository
protocol GitHubRepository {
    
    func fetchStargazers(request: ListStargazersRequest) -> AnyPublisher<[Stargazer], Error>
}

extension GitHubRepository {
        
    var jsonDecoder: JSONDecoder {
        let result = JSONDecoder()
        result.keyDecodingStrategy = .convertFromSnakeCase
        result.dateDecodingStrategy = .iso8601
        return result
    }
}

// MARK: - RemoteGitHubRepository
final class RemoteGitHubRepository {
    
    private lazy var apiClient: ApiClient = {
        var client = Injector.shared.resolve(ApiClient.self)
        client.jsonDecoder = self.jsonDecoder
        return client
    }()
}

// MARK: - API
extension RemoteGitHubRepository: GitHubRepository {
    
    func fetchStargazers(request: ListStargazersRequest) -> AnyPublisher<[Stargazer], Error> {
        
        return self.apiClient.request(request: request)
            .map { response -> [Stargazer] in
                let result = response.map { item in
                    Stargazer(user: item.user, timestamp: item.starredAt)
                }
                return result
            }
            .eraseToAnyPublisher()
    }
}
