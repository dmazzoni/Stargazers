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
    @Published var repositoryOwner: String = ""
    @Published var repositoryName: String = ""
    
    // ViewModel -> View
    @Published var stargazers: [Stargazer] = []
    @Published var isSearchDisabled: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorModel: SimpleErrorModel?
    
    private lazy var gitHubRepository: GitHubRepository = {
        Injector.shared.resolve(GitHubRepository.self)
    }()
    
    private var currentPage: Int = 1
    private var cancelBag = Set<AnyCancellable>()
    
    init() {
        self.setupBindings()
    }
}

// MARK: - API
extension StargazerListViewModel {
    
    func didRequestStargazerUpdate() {
        self.stargazers = []
        self.currentPage = 1
        self.loadNextPage()
    }
    
    func didRequestNextPage() {
        self.loadNextPage()
    }
}

// MARK: - Private
private extension StargazerListViewModel {
    
    func setupBindings() {
        
        $repositoryName.combineLatest($repositoryOwner, $isLoading)
            .map { name, owner, isLoading in
                name.isEmpty || owner.isEmpty || isLoading
            }
            .assign(to: \.isSearchDisabled, on: self)
            .store(in: &self.cancelBag)
    }
    
    func loadNextPage() {
        
        self.isLoading = true
        let request = ListStargazersRequest(
            repositoryOwner: repositoryOwner,
            repositoryName: repositoryName,
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
        }
        .store(in: &self.cancelBag)
    }
}
