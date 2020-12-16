//
//  ASOAuthRepository.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 16/12/20.
//

import AuthenticationServices
import Combine

// MARK: - ASOAuthRepository
final class ASOAuthRepository: NSObject {
    
    private lazy var oauthConfiguration: OAuthConfiguration = {
        Injector.shared.resolve(OAuthConfiguration.self)
    }()
    
    private lazy var apiClient: ApiClient = {
        Injector.shared.resolve(ApiClient.self)
    }()
    
    private lazy var apiAuthorizationProvider: ApiAuthorizationProvider = {
        Injector.shared.resolve(ApiAuthorizationProvider.self)
    }()
}

// MARK: - ASWebAuthenticationPresentationContextProviding
extension ASOAuthRepository: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        ASPresentationAnchor()
    }
}

// MARK: - API
extension ASOAuthRepository: OAuthRepository {
    
    func login() -> AnyPublisher<OAuthToken, OAuthRepositoryError> {
        
        return self.performAuthorization()
            .flatMap {
                self.performCodeExchange(code: $0)
            }
            .eraseToAnyPublisher()
    }
    
    func logout() {
        self.apiAuthorizationProvider.authToken = nil
    }
    
    var isLoggedIn: Bool {
        self.apiAuthorizationProvider.authToken != nil
    }
}

// MARK: - Authorization flow steps
private extension ASOAuthRepository {
    
    func performAuthorization() -> AnyPublisher<String, OAuthRepositoryError> {
        
        let oauthConfiguration = self.oauthConfiguration
        let request = AuthorizationCodeRequest(oauthConfiguration: oauthConfiguration)
        guard let authorizationURL = try? request.toURLRequest().url else {
            return Fail(
                outputType: String.self,
                failure: OAuthRepositoryError.invalidAuthorizationURL
            ).eraseToAnyPublisher()
        }
        
        let callbackScheme = oauthConfiguration.callbackScheme
        let publisher = Future<URL, Error> { [weak self] subscriber in
            
            let session = ASWebAuthenticationSession(
                url: authorizationURL,
                callbackURLScheme: callbackScheme) { callbackURL, error in
                
                if let error = error {
                    subscriber(.failure(error))
                    return
                }
                
                guard let callbackURL = callbackURL else {
                    subscriber(.failure(OAuthRepositoryError.missingCallbackURL))
                    return
                }
                
                subscriber(.success(callbackURL))
            }
            
            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }
        .tryMap {
            try $0.processAsCallbackURL(configuration: oauthConfiguration)
        }
        .mapError {
            OAuthRepositoryError(authorizationError: $0)
        }
        
        return publisher.eraseToAnyPublisher()
    }
    
    func performCodeExchange(code: String) -> AnyPublisher<OAuthToken, OAuthRepositoryError> {
        
        let oauthConfiguration = self.oauthConfiguration
        let request = AccessTokenRequest(
            oauthConfiguration: oauthConfiguration,
            code: code
        )
        
        return self.apiClient.request(request: request)
            .map { [weak self] response in
                let token = OAuthToken(
                    tokenType: response.tokenType,
                    value: response.accessToken
                )
                self?.apiAuthorizationProvider.authToken = token
                return token
            }
            .mapError {
                OAuthRepositoryError(tokenError: $0)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Private
private extension OAuthRepositoryError {
    
    init(authorizationError: Swift.Error) {
        
        if let repositoryError = authorizationError as? OAuthRepositoryError {
            self = repositoryError
            return
        }
        
        guard let sessionError = authorizationError as? ASWebAuthenticationSessionError else {
            self = .authorizationError(reason: authorizationError)
            return
        }
        
        switch sessionError.code {
        case .canceledLogin:
            self = .cancelled
        default:
            self = .authorizationError(reason: sessionError)
        }
    }
    
    init(tokenError: Swift.Error) {
        
        if let repositoryError = tokenError as? OAuthRepositoryError {
            self = repositoryError
            return
        }
        
        self = .codeExchangeError(reason: tokenError)
    }
}

private extension URL {
    
    func processAsCallbackURL(
        configuration: OAuthConfiguration
    ) throws -> String {
        
        guard let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false) else {
            throw OAuthRepositoryError.invalidCallback
        }
        
        guard let configurationComponents = configuration.callbackUrlComponents else {
            throw OAuthRepositoryError.invalidCallback
        }
        
        guard urlComponents.scheme == configurationComponents.scheme,
              urlComponents.host == configurationComponents.host,
              urlComponents.path == configurationComponents.path else {
            throw OAuthRepositoryError.invalidCallback
        }
        
        guard let queryItems = urlComponents.queryItems, !queryItems.isEmpty else {
            throw OAuthRepositoryError.invalidCallback
        }
        
        let codeItem = queryItems.first { $0.name == "code" }
        guard let code = codeItem?.value, !code.isEmpty else {
            throw OAuthRepositoryError.invalidCallback
        }
        
        return code
    }
}
