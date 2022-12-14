//
//  ConstantsTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class ConstantsTests: XCTestCase {
    private let baseMoviesUrl = "https://api.themoviedb.org/3"
    private let baseImagesUrl = "https://image.tmdb.org/t/p/original"
    
    func test_baseMoviesUrl() {
        XCTAssertEqual(Constants.baseMoviesUrl, baseMoviesUrl)
        XCTAssertNotEqual(Constants.baseMoviesUrl.last, "/", "Added a backslash in the Endpoint enum")
    }
    
    func test_baseImagesUrl() {
        XCTAssertEqual(Constants.baseImagesUrl, baseImagesUrl)
        XCTAssertNotEqual(Constants.baseImagesUrl.last, "/", "Added a backslash in the Endpoint enum")
    }
}
