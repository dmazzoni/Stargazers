//
//  Injector.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Foundation
import Swinject

// MARK: - Injector
final class Injector {
    
    static let shared = Injector()
    
    private let container = Container()
    
    private init() {
        self.setupContainer()
    }
}

// MARK: - API
extension Injector {
    
    func resolve<Service>(_ serviceType: Service.Type) -> Service {
        // swiftlint:disable:next force_unwrapping
        self.container.resolve(serviceType)!
    }
}

// MARK: - Private
private extension Injector {
    
    func setupContainer() {
        
        self.container.register(ApiClient.self) { _ in
            AlamofireNetworkClient()
        }
        
        self.container.register(ApiAuthorizationProvider.self) { _ in
            InMemoryTokenStorage()
        }
        .inObjectScope(.container)
        
        self.container.register(GitHubRepository.self) { _ in
            RemoteGitHubRepository()
        }
        
        self.container.register(OAuthRepository.self) { _ in
            ASOAuthRepository()
        }
        
        self.container.register(OAuthConfiguration.self) { _ in
            OAuthConfiguration(
                clientId: "931f93c018859d09a4ee",
                clientSecret: "fc0840b208509b552ada91218f6d1309dda224a0",
                callbackScheme: "dmazzoni",
                callbackUrl: "dmazzoni://oauth-callback/"
            )
        }
        .inObjectScope(.container)
        
        self.container.register(StargazerListViewModel.self) { resolver in
            // swiftlint:disable force_unwrapping
            StargazerListViewModel(
                gitHubRepository: resolver.resolve(GitHubRepository.self)!,
                oauthRepository: resolver.resolve(OAuthRepository.self)!
            )
            // swiftlint:enable force_unwrapping
        }
    }
}
