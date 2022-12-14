//
//  DIContainerPerformanceTests.swift
//  MoviesPerformanceTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class DIContainerPerformanceTests: XCTestCase {
    func test_boot_performance() {
        measure {
            let _ = DIContainer.boot()
        }
    }
}
