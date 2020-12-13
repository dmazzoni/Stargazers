//
//  URLRequestCompatible.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation

// MARK: - URLRequestCompatible
public protocol URLRequestCompatible {
    
    func toURLRequest() throws -> URLRequest
}

// MARK: - URLRequest convenience
extension URLRequest: URLRequestCompatible {
    
    public func toURLRequest() throws -> URLRequest { self }
}
