//
//  ApiClient.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Combine
import Foundation

// MARK: - ApiClient
protocol ApiClient {
    
    var jsonDecoder: JSONDecoder { get set }
    
    func request<T: ApiRequest>(request: T) -> AnyPublisher<T.Response, Swift.Error>
}
