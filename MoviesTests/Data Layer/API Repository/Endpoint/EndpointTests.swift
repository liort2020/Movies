//
//  EndpointTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class EndpointTests: XCTestCase {
    private var testURL = TestAPIRepository.testMoviesURL
    
    func test_getMovies() throws {
        // Given
        let testableObject = try XCTUnwrap(MoviesAPIRepository.MoviesEndpoint.getUpcomingMovies)
        
        do {
            // When
            let urlRequest = try testableObject.request(url: testURL)
            
            // Then
            XCTAssertNotNil(urlRequest)
            // path
            let request = try XCTUnwrap(urlRequest)
            XCTAssertNotNil(request.url)
            // query parameters
            let query = try XCTUnwrap(request.url?.query)
            XCTAssertEqual(query, "api_key=\(Constants.apiKey)")
            // method
            XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
            // headers
            XCTAssertEqual(request.allHTTPHeaderFields, ["Content-Type": "application/json"])
            // body
            XCTAssertNil(request.httpBody)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
}
