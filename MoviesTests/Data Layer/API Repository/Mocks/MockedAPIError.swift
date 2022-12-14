//
//  MockedAPIError.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

enum MockedAPIError: Error {
    case request
    case response
}
