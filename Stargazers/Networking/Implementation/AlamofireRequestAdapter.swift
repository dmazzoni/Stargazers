//
//  AlamofireRequestAdapter.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import Foundation
import Alamofire

// MARK: - AlamofireRequestAdapter
final class AlamofireRequestAdapter {
    
    private lazy var authorizationProvider: ApiAuthorizationProvider = {
        Injector.shared.resolve(ApiAuthorizationProvider.self)
    }()
}

// MARK: - RequestAdapter conformance
extension AlamofireRequestAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        var request = urlRequest

        if let authorization = self.authorizationProvider.authorizationHeader {
            request.headers.update(name: "Authorization", value: authorization)
        }
        
        completion(.success(request))
    }
}
