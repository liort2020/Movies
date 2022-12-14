//
//  MoviesLaunchPerformance.swift
//  MoviesUITests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest

class MoviesLaunchPerformance: XCTestCase {
    private var application: XCUIApplication?
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
    }
    
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            application?.launch()
        }
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
