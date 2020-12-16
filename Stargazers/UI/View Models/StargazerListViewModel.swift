//
//  StargazerListViewModel.swift
//  Stargazers
//
//  Created by Davide Mazzoni on 12/12/20.
//

import Combine
import Foundation

// MARK: - StargazerListViewModel
final class StargazerListViewModel: ObservableObject {
    
    // View -> ViewModel
    @Published var repo: Repo = Repo()
    
    // ViewModel -> View
    @Published var stargazers: [Stargazer] = []
    @Published var loginButtonTitle: String = "Login"
    @Published var isSearchDisabled: Bool = false
    @Published var isLoginDisabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var isAuthenticating: Bool = false
    @Published var showListPlaceholder: Bool = false
    @Published var errorModel: SimpleErrorModel?
    
    private let gitHubRepository: GitHubRepository
    private let oauthRepository: OAuthRepository
    
    private var currentPage: Int = 1
    private var cancelBag = Set<AnyCancellable>()
    
    init(
        gitHubRepository: GitHubRepository,
        oauthRepository: OAuthRepository
    ) {
        self.gitHubRepository = gitHubRepository
        self.oauthRepository = oauthRepository
        self.setupBindings()
    }
}

// MARK: - API
extension StargazerListViewModel {
    
    func didRequestStargazerUpdate() {
        
        if !self.stargazers.isEmpty {
            self.stargazers = []
        }
        self.currentPage = 1
        self.didRequestNextPage()
    }
    
    func didRequestNextPage() {
        self.loadNextPage()
    }
    
    func didTapLoginButton() {
        
        if self.oauthRepository.isLoggedIn {
            self.didRequestLogout()
        } else {
            self.didRequestLogin()
        }
    }
}

// MARK: - Private
private extension StargazerListViewModel {
    
    func setupBindings() {
        
        $repo.combineLatest($isLoading, $isAuthenticating)
            .map { repo, isLoading, isAuthenticating in
                repo.name.isEmpty || repo.owner.isEmpty || isLoading || isAuthenticating
            }
            .assign(to: \.isSearchDisabled, on: self)
            .store(in: &self.cancelBag)
        
        $isAuthenticating
            .assign(to: \.isLoginDisabled, on: self)
            .store(in: &self.cancelBag)
    }
    
    func loadNextPage() {
        
        guard !self.isLoading else {
            return
        }
        
        self.isLoading = true
        let request = ListStargazersRequest(
            repo: self.repo,
            page: self.currentPage
        )
        
        self.gitHubRepository.fetchStargazers(request: request)
        .sink { [weak self] completion in
            self?.isLoading = false
            if case let .failure(error) = completion {
                self?.errorModel = SimpleErrorModel(message: error.localizedDescription)
            }
        } receiveValue: { [weak self] value in
            self?.isLoading = false
            self?.stargazers += value
            self?.currentPage += 1
            self?.showListPlaceholder = (self?.stargazers.isEmpty ?? true)
        }
        .store(in: &self.cancelBag)
    }
    
    func didRequestLogin() {
        
        self.isAuthenticating = true
        self.oauthRepository.login()
            .sink { [weak self] completion in
                self?.isAuthenticating = false
                self?.updateLoginButtonTitle()
                if case let .failure(error) = completion {
                    
                    switch error {
                    case .cancelled:
                        break
                    default:
                        self?.errorModel = SimpleErrorModel(message: error.localizedDescription)
                    }
                }
            } receiveValue: { [weak self] _ in
                self?.isAuthenticating = false
            }
            .store(in: &cancelBag)
    }
    
    func didRequestLogout() {
        self.oauthRepository.logout()
        self.updateLoginButtonTitle()
    }
    
    func updateLoginButtonTitle() {
        
        let title: String
        if self.oauthRepository.isLoggedIn {
            title = "Logout"
        } else {
            title = "Login"
        }
        
        self.loginButtonTitle = title
    }
}
