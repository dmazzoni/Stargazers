//
//  ApiRequest.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation

// MARK: - ApiRequest
protocol ApiRequest: URLRequestCompatible {
    
    associatedtype Response: Decodable
    
    var method: ApiMethod { get }
    var headers: [String: String] { get }
    var urlComponents: URLComponents? { get }
}

extension ApiRequest {
    
    var headers: [String: String] { [:] }
}

// MARK: - URLRequestCompatible
extension ApiRequest {
    
    func toURLRequest() throws -> URLRequest {
        
        guard let urlComponents = self.urlComponents else {
            throw ApiRequestError.invalidURLComponents
        }
        
        let url = try urlComponents.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        
        for header in self.headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return urlRequest
    }
}

// MARK: - ApiMethod
enum ApiMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

// MARK: - ApiRequestError
enum ApiRequestError: Swift.Error {
    case invalidURLComponents
}
