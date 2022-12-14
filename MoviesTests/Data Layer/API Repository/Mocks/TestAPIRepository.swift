//
//  TestAPIRepository.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

class TestAPIRepository: APIRepository {
    static let testMoviesURL = "https://test.com"
    
    let session: URLSession = .mockedSession
    let baseURL = testMoviesURL
}
