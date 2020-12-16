//
//  AlamofireRequestInterceptor.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation
import Alamofire

// MARK: - AlamofireRequestInterceptor
final class AlamofireRequestInterceptor {
    
    private lazy var authorizationProvider: ApiAuthorizationProvider = {
        Injector.shared.resolve(ApiAuthorizationProvider.self)
    }()
}

// MARK: - RequestInterceptor conformance
extension AlamofireRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest

        if let authorization = self.authorizationProvider.authorizationHeader {
            request.headers.update(name: "Authorization", value: authorization)
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        completion(.doNotRetry)
    }
}
