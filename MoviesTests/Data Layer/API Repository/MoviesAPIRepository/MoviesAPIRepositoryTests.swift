//
//  MoviesAPIRepositoryTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
import CoreData
@testable import Movies

final class MoviesAPIRepositoryTests: XCTestCase {
    private let baseUrl = TestAPIRepository.testMoviesURL
    
    private var testableObject: MoviesAPIRepository?
    
    override func setUp() {
        super.setUp()
        testableObject = MoviesAPIRepository(session: .mockedSession, baseURL: baseUrl)
    }
    
    func test_getMovies() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let expectedNumberOfItems = 20
        let page = 1
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockedURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockedAPIError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockedAPIError.response }
            return (response, data)
        }
        
        do {
            // When
            let movies = try await testableObject.getMovies(by: .upcoming, page: page)
            // Then
            XCTAssertNotNil(movies.movies)
            let numberOfMovies = movies.movies?.count ?? 0
            XCTAssertEqual(numberOfMovies, expectedNumberOfItems, "Receive \(numberOfMovies) items instead of \(expectedNumberOfItems) items")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
