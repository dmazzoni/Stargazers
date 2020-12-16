//
//  StargazerListViewModelTests.swift
//  StargazersTests
//
//  Created by Davide Mazzoni on 15/12/20.
//

import Combine
import CombineExpectations
import XCTest

@testable import Stargazers

// MARK: - StargazerListViewModelTests
final class StargazerListViewModelTests: XCTestCase {
    
    private var gitHubRepository: MockGitHubRepository!
    private var viewModel: StargazerListViewModel!
    
    override func setUp() {
        let mockRepository = MockGitHubRepository()
        self.gitHubRepository = mockRepository
        self.viewModel = StargazerListViewModel(
            gitHubRepository: mockRepository,
            oauthRepository: MockOAuthRepository()
        )
    }
    
    func testListIsInitiallyEmpty() {
        XCTAssertTrue(self.viewModel.stargazers.isEmpty)
    }
    
    func testSearchIsInitiallyDisabled() {
        XCTAssertTrue(self.viewModel.isSearchDisabled)
    }
    
    func testSearchIsEnabledWhenFormIsFilled() throws {
        
        let expectedValues = [true, false]
        let recorder = self.viewModel.$isSearchDisabled.record()
        
        self.viewModel.repo = self.sampleRepo
        
        let elements = try wait(for: recorder.prefix(2), timeout: 1.0)
        XCTAssertEqual(expectedValues, elements)
    }
    
    func testUpdateRequestTriggersNetworkCall() {
        
        let expectation = XCTestExpectation()
        self.gitHubRepository.onFetchStargazers = { _ in
            expectation.fulfill()
            return Result.success([]).publisher.eraseToAnyPublisher()
        }
        
        self.viewModel.repo = self.sampleRepo
        self.viewModel.didRequestStargazerUpdate()
        
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateRequestUsesCurrentRepoInfo() {
        
        let expectedRepo = self.sampleRepo
        let expectation = XCTestExpectation()
        self.gitHubRepository.onFetchStargazers = { request in
            
            if request.repo != expectedRepo {
                expectation.isInverted = true
            }
            
            expectation.fulfill()
            return Result.success([]).publisher.eraseToAnyPublisher()
        }
        
        self.viewModel.repo = expectedRepo
        self.viewModel.didRequestStargazerUpdate()
        
        self.wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateResponseIsPublished() throws {
        
        let stargazers = self.sampleStargazerList(size: 1)
        self.gitHubRepository.onFetchStargazers = { _ in
            return Result.success(stargazers).publisher.eraseToAnyPublisher()
        }
        
        let recorder = self.viewModel.$stargazers.record()
        self.viewModel.didRequestStargazerUpdate()
        
        let elements = try wait(for: recorder.prefix(2), timeout: 1.0)
        XCTAssertEqual([[], stargazers], elements)
    }
    
    func testNextPageFetchAccumulatesValues() throws {
        
        let stargazers = self.sampleStargazerList(size: 4)
        let firstPage = Array(stargazers.dropLast(2))
        let secondPage = Array(stargazers.dropFirst(2))
        
        var pageIndex = 0
        self.gitHubRepository.onFetchStargazers = { _ in
            let values = pageIndex == 0 ? firstPage : secondPage
            pageIndex += 1
            return Result.success(values).publisher.eraseToAnyPublisher()
        }
        
        let recorder = self.viewModel.$stargazers.record()
        self.viewModel.didRequestStargazerUpdate()
        self.viewModel.didRequestNextPage()
        
        let elements = try wait(for: recorder.prefix(3), timeout: 1.0)
        XCTAssertEqual([[], firstPage, stargazers], elements)
    }
    
    func testUpdateRequestResetsValues() throws {
        
        let stargazers = self.sampleStargazerList(size: 4)
        let firstResults = Array(stargazers.dropLast(2))
        let secondResults = Array(stargazers.dropFirst(2))
        
        var requestIndex = 0
        self.gitHubRepository.onFetchStargazers = { _ in
            let values = requestIndex == 0 ? firstResults : secondResults
            requestIndex += 1
            return Result.success(values).publisher.eraseToAnyPublisher()
        }
        
        let recorder = self.viewModel.$stargazers.record()
        self.viewModel.didRequestStargazerUpdate()
        self.viewModel.didRequestStargazerUpdate()
        
        let elements = try wait(for: recorder.prefix(4), timeout: 1.0)
        XCTAssertEqual([[], firstResults, [], secondResults], elements)
    }
}

// MARK: - Helpers
private extension StargazerListViewModelTests {
    
    var sampleRepo: Repo {
        Repo(owner: "Foo", name: "Bar")
    }
    
    func sampleStargazerList(size: UInt) -> [Stargazer] {
        
        var list: [Stargazer] = []
        for index in 1...size {
            let item = Stargazer(user: User(login: "\(index)", avatarUrl: nil), timestamp: Date())
            list.append(item)
        }
        
        return list
    }
}
