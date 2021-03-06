//
//  ListStargazers.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation

// MARK: - ListStargazersRequest
struct ListStargazersRequest: GitHubRequest {
    
    let repo: Repo
    let page: Int
}

// MARK: - ApiRequest conformance
extension ListStargazersRequest: ApiRequest {
    
    typealias Response = [ListStargazersResponseItem]
    
    var urlComponents: URLComponents? {
        
        guard var urlComponents = URLComponents(url: self.baseURL, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        urlComponents.path = "/repos/\(self.repo.owner)/\(self.repo.name)/stargazers"
        urlComponents.queryItems = self.queryItems
        
        return urlComponents
    }
    
    var method: ApiMethod { .get }
    
    var headers: [String: String] {
        [
            "Accept": "application/json; application/vnd.github.v3.star+json"
        ]
    }
}
    
private extension ListStargazersRequest {
    
    var queryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "page", value: String(self.page))
        ]
    }
}

// MARK: - ListStargazersResponseItem
struct ListStargazersResponseItem: Decodable {
    
    let starredAt: Date
    let user: User
}
