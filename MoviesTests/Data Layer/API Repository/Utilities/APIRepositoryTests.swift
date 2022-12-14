//
//  APIRepositoryTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class APIRepositoryTests: XCTestCase {
    private var moviesEndpoint: MoviesAPIRepository.MoviesEndpoint?
    
    private var testableObject: TestAPIRepository?
    
    override func setUp() {
        super.setUp()
        moviesEndpoint = MoviesAPIRepository.MoviesEndpoint.getUpcomingMovies
        testableObject = TestAPIRepository()
    }
    
    func test_requestURL() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let expectedNumberOfItems = 20
        let page = 1
        let moviesEndpoint = try XCTUnwrap(moviesEndpoint)
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockedURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockedAPIError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) else { throw MockedAPIError.response }
            return (response, data)
        }
        
        do {
            // When
            let movies: MoviesListAPI = try await testableObject.get(endpoint: moviesEndpoint, page: page)
            
            // Then
            XCTAssertNotNil(movies.movies)
            let numberOfItems = movies.movies?.count ?? 0
            XCTAssertEqual(numberOfItems, expectedNumberOfItems, "Receive \(numberOfItems) items instead of \(expectedNumberOfItems) items")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_requestURL_apiError_invalidStatusCode() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let page = 1
        let invalidStatusCode = 199
        let moviesEndpoint = try XCTUnwrap(moviesEndpoint)
        let data = try XCTUnwrap(MockedMovie.getMoviesData(fromResource: MockedMovie.mockedMoviesFileName))
        
        MockedURLProtocol.requestHandler = { request in
            guard let url = request.url else { throw MockedAPIError.request }
            guard let response = HTTPURLResponse(url: url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil) else { throw MockedAPIError.response }
            return (response, data)
        }
        
        do {
            // When
            let _: MoviesListAPI = try await testableObject.get(endpoint: moviesEndpoint, page: page)
            XCTFail("Expected to get a APIError")
        } catch {
            // Then
            XCTAssertEqual(error.localizedDescription, APIError.httpCode(HTTPError(code: invalidStatusCode)).localizedDescription, "Expected to get invalid status code, and got: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        moviesEndpoint = nil
        testableObject = nil
        super.tearDown()
    }
}
