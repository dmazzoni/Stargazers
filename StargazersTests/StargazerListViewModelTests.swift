//
//  StargazerListViewModelTests.swift
//  StargazersTests
//
//  Created by Davide Mazzoni on 15/12/20.
//

import Combine
import XCTest

@testable import Stargazers

// MARK: - StargazerListViewModelTests
final class StargazerListViewModelTests: XCTestCase {
    
    private var defaultRepo: Repo!
    private var gitHubRepository: MockGitHubRepository!
    private var viewModel: StargazerListViewModel!
    
    override func setUp() {
        let mockRepository = MockGitHubRepository()
        self.gitHubRepository = mockRepository
        self.viewModel = StargazerListViewModel(gitHubRepository: mockRepository)
        self.defaultRepo = Repo(owner: "Foo", name: "Bar")
    }
    
    func testStargazersListIsInitiallyEmpty() {
        XCTAssertTrue(self.viewModel.stargazers.isEmpty)
    }
    
    func testSearchIsInitiallyDisabled() {
        XCTAssertTrue(self.viewModel.isSearchDisabled)
    }
    
    func testSearchIsEnabledWhenFormIsFilled() {
        
        self.viewModel.repo = self.defaultRepo
        XCTAssertFalse(self.viewModel.isSearchDisabled)
    }
    
    func testStargazerUpdateRequestTriggersNetworkCall() {
        
        let expectation = XCTestExpectation()
        self.gitHubRepository.onFetchStargazers = { _ in
            expectation.fulfill()
            return Result.success([]).publisher.eraseToAnyPublisher()
        }
        
        self.viewModel.repo = self.defaultRepo
        self.viewModel.didRequestStargazerUpdate()
        
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func testStargazerUpdateRequestUsesCurrentRepoInfo() {
        
        let expectedRepo = self.defaultRepo
        let expectation = XCTestExpectation()
        self.gitHubRepository.onFetchStargazers = { request in
            
            if request.repo != expectedRepo {
                expectation.isInverted = true
            }
            
            expectation.fulfill()
            return Result.success([]).publisher.eraseToAnyPublisher()
        }
        
        self.viewModel.repo = self.defaultRepo
        self.viewModel.didRequestStargazerUpdate()
        
        self.wait(for: [expectation], timeout: 1.0)
    }
}
