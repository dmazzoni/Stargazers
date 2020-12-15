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
        
        self.container.register(GitHubRepository.self) { _ in
            RemoteGitHubRepository()
        }
        
        self.container.register(StargazerListViewModel.self) { resolver in
            let repository = resolver.resolve(GitHubRepository.self)!
            return StargazerListViewModel(gitHubRepository: repository)
        }
    }
}
