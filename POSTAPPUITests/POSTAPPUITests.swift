//
//  POSTAPPUITests.swift
//  POSTAPPUITests
//
//  Created by Jorge Jair Ramirez Gaston Zuloeta on 5/01/25.
//

import XCTest
@testable import POSTAPP

@MainActor
class CreatePostViewModelTests: XCTestCase {
    
    class MockNetworkService: NetworkService {
        var shouldSucceed: Bool = true
        var capturedPost: Post?
        
       func createPost(_ post: Post) async throws -> Post {
            capturedPost = post
            if shouldSucceed {
                return Post(id: 1, title: post.title, body: post.body, userId: post.userId)
            } else {
                throw NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error de prueba"])
            }
        }
    }
    
    var viewModel: CreatePostViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() async throws {
        mockNetworkService = MockNetworkService()
        viewModel = CreatePostViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockNetworkService = nil
    }
    
    func test_createPost_success() async throws {
        // Given
        viewModel.title = "Test Title"
        viewModel.body = "Test Body"
        mockNetworkService.shouldSucceed = true
        
        // When
        await viewModel.createPost()
        
        // Then
        XCTAssertNil(viewModel.error)
        XCTAssertNotNil(viewModel.successMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.body, "")
        
        XCTAssertEqual(mockNetworkService.capturedPost?.title, "Test Title")
        XCTAssertEqual(mockNetworkService.capturedPost?.body, "Test Body")
    }
    
    func test_createPost_failure() async throws {
        // Given
        viewModel.title = "Test Title"
        viewModel.body = "Test Body"
        mockNetworkService.shouldSucceed = false
        
        // When
        await viewModel.createPost()
        
        // Then
        XCTAssertNotNil(viewModel.error)
        XCTAssertNil(viewModel.successMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.title, "Test Title")
        XCTAssertEqual(viewModel.body, "Test Body")
    }
    
    func test_initialState() throws {
        XCTAssertEqual(viewModel.title, "")
        XCTAssertEqual(viewModel.body, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
        XCTAssertNil(viewModel.successMessage)
    }
}
