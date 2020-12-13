//
//  GitHubService.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Combine
import Foundation

// MARK: - GitHubService
protocol GitHubService {
    
    func fetchStargazers(
        repositoryOwner: String,
        repositoryName: String,
        page: Int
    ) -> AnyPublisher<[Stargazer], Error>
}

extension GitHubService {
        
    var jsonDecoder: JSONDecoder {
        let result = JSONDecoder()
        result.keyDecodingStrategy = .convertFromSnakeCase
        result.dateDecodingStrategy = .iso8601
        return result
    }
}

// MARK: - RemoteGitHubService
final class RemoteGitHubService {
    
    private lazy var apiClient: ApiClient = {
        var client = Injector.shared.resolve(ApiClient.self)
        client.jsonDecoder = self.jsonDecoder
        return client
    }()
}

// MARK: - API
extension RemoteGitHubService: GitHubService {
    
    func fetchStargazers(
        repositoryOwner: String,
        repositoryName: String,
        page: Int
    ) -> AnyPublisher<[Stargazer], Error> {
        
        let request = ListStargazersRequest(repositoryOwner: repositoryOwner, repositoryName: repositoryName, page: page)
        
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
