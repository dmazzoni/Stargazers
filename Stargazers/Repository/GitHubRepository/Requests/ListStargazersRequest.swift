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
    
    var path: String {
        "/repos/\(self.repo.owner)/\(self.repo.name)/stargazers"
    }
    
    var method: ApiMethod { .get }
    
    var headers: [String: String] {
        [
            "Accept": "application/json; application/vnd.github.v3.star+json"
        ]
    }
    
    var queryItems: [String: String] {
        [
            "page": String(self.page)
        ]
    }
}

// MARK: - ListStargazersResponseItem
struct ListStargazersResponseItem: Decodable {
    
    let starredAt: Date
    let user: User
}
