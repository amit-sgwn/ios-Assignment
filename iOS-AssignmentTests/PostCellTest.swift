//
//  PostCellTest.swift
//  iOS-AssignmentTests
//
//  Created by Amit Kumar on 03/05/24.
//

import XCTest
import XCTest
@testable import iOS_Assignment // Import your app module

final class PostTests: XCTestCase {
    
    func testPostDecoding() {
            // Given
            let jsonData = """
                {
                    "id": 1,
                    "title": "Title 1",
                    "body": "Body 1",
                    "isProcessing": true
                }
                """.data(using: .utf8)!
            
            // When
            let decoder = JSONDecoder()
            do {
                let post = try decoder.decode(Post.self, from: jsonData)
                
                // Then
                XCTAssertEqual(post.id, 1, "Post id should match")
                XCTAssertEqual(post.title, "Title 1", "Post title should match")
                XCTAssertEqual(post.body, "Body 1", "Post body should match")
                XCTAssertTrue(post.isProcessing, "isProcessing should be true")
            } catch {
                XCTFail("Failed to decode Post: \(error)")
            }
        }
}


class NetworkServiceTests: XCTestCase {
    
    func testFetchData_Success() {
        // Given
        let mockData = """
            {
                "id": 1,
                "title": "Test Title",
                "body": "Test Body"
            }
            """.data(using: .utf8)!
        let mockURL = URL(string: "https://example.com")!
        
        let networkService = MockNetworkService()

        let expectation = self.expectation(description: "Completion handler called")
        
        // When
        networkService.fetchData(from: mockURL) { (result: Result<Post, Error>) in
            switch result {
            case .success(let post):
                // Then
                XCTAssertEqual(post.id, 1)
                XCTAssertEqual(post.title, "Test Title")
                XCTAssertEqual(post.body, "Test Body")
                XCTAssertFalse(post.isProcessing)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetching data failed with error: \(error)")
            }
        }
        
        // Wait for the expectation to be fulfilled
        waitForExpectations(timeout: 5, handler: nil)
    }
    
   
}



// Mock implementation of the network service for testing
class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed: Bool // Flag to control the behavior of the mock
    
    init(shouldSucceed: Bool = true) {
        self.shouldSucceed = shouldSucceed
    }
    
    func fetchData<T: Decodable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        if shouldSucceed {
            // Simulate successful response with mock data
            let postJSONString = """
            {
                "id": 1,
                "title": "Test Title",
                "body": "Test Body"
            }
            """
            
            // Convert the JSON string to Data
            guard let mockData = postJSONString.data(using: .utf8) else {
                fatalError("Failed to convert JSON string to Data")
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: mockData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        } else {
            // Simulate failure with a generic error
            let error = NSError(domain: "MockNetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock failure"])
            completion(.failure(error))
        }
    }
}
