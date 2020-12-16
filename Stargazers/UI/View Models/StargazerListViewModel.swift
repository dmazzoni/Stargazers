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
    @Published var isSearchDisabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var showListPlaceholder: Bool = false
    @Published var errorModel: SimpleErrorModel?
    
    private let gitHubRepository: GitHubRepository
    
    private var currentPage: Int = 1
    private var cancelBag = Set<AnyCancellable>()
    
    init(gitHubRepository: GitHubRepository) {
        self.gitHubRepository = gitHubRepository
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
}

// MARK: - Private
private extension StargazerListViewModel {
    
    func setupBindings() {
        
        $repo.combineLatest($isLoading)
            .map { repo, isLoading in
                repo.name.isEmpty || repo.owner.isEmpty || isLoading
            }
            .assign(to: \.isSearchDisabled, on: self)
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
}
