//
//  AlamofireApiClient.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Combine
import Foundation
import Alamofire

// MARK: - AlamofireNetworkClient
final class AlamofireNetworkClient {
    
    var jsonDecoder: JSONDecoder
    
    private let session: Alamofire.Session
    
    init() {
        self.session = Alamofire.Session()
        self.jsonDecoder = JSONDecoder()
    }
}

// MARK: - ApiClient conformance
extension AlamofireNetworkClient: ApiClient {
    
    func request<T>(request: T) -> AnyPublisher<T.Response, Swift.Error> where T: ApiRequest {
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.toURLRequest()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return self.session.request(urlRequest)
            .validate()
            .publishDecodable(type: T.Response.self, decoder: self.jsonDecoder)
            .value()
            .mapError { $0 as Swift.Error }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
