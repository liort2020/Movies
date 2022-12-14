//
//  EndpointPerformanceTests.swift
//  MoviesPerformanceTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class EndpointPerformanceTests: XCTestCase {
    private let testURL = "https://test.com"
    
    func test_getUpcomingMovies_performance() throws {
        let testableObject = MoviesAPIRepository.MoviesEndpoint.getUpcomingMovies
        
        measure {
            let _ = try? testableObject.request(url: testURL)
        }
    }
}
