//
//  ListStargazersRequestTests.swift
//  StargazersTests
//
//  Created by Davide Mazzoni on 12/12/20.
//

import XCTest
@testable import Stargazers

class ListStargazersRequestTests: XCTestCase {
    
    private var repo: Repo!
    
    override func setUp() {
        self.repo = Repo(owner: "Foo", name: "Bar")
    }
    
    func testBaseURLIsGitHub() {
        let request = ListStargazersRequest(repo: self.repo, page: 1)
        XCTAssertEqual("https://api.github.com", request.baseURL.absoluteString)
    }
    
    func testURLRequestConversionSucceeds() {
        let request = ListStargazersRequest(repo: self.repo, page: 1)
        XCTAssertNoThrow(try request.toURLRequest())
    }
    
    func testURLRequestMethodIsGet() throws {
        
        let request = ListStargazersRequest(repo: self.repo, page: 1)
        let urlRequest = try request.toURLRequest()
        
        XCTAssertEqual("GET", urlRequest.httpMethod)
    }
    
    func testURLRequestQueryContainsPage() throws {
        
        let expectedPage = 42
        let request = ListStargazersRequest(repo: self.repo, page: expectedPage)
        
        let urlRequest = try request.toURLRequest()
        let urlComponents = urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        }
        
        let pageItem = urlComponents?.queryItems?.first { $0.name == "page" }
        XCTAssertEqual(String(expectedPage), pageItem?.value)
    }
    
    func testURLRequestPath() throws {
        
        self.repo.owner = "OwnerName"
        self.repo.name = "RepoName"
        let expectedPath = "/repos/\(self.repo.owner)/\(self.repo.name)/stargazers"
        
        let request = ListStargazersRequest(repo: self.repo, page: 1)
        
        let urlRequest = try request.toURLRequest()
        let urlComponents = urlRequest.url.flatMap {
            URLComponents(url: $0, resolvingAgainstBaseURL: false)
        }
        
        XCTAssertEqual(expectedPath, urlComponents?.path)
    }
}
