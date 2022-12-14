//
//  MoviesListViewUITests.swift
//  MoviesUITests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class MoviesListViewUITests: XCTestCase {
    private var application: XCUIApplication?
    private let navigationBarTitle = "Movies"
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        application = XCUIApplication()
        application?.launch()
    }
    
    func test_navigation_bar_exist() throws {
        let navigationBar = try XCTUnwrap(application).navigationBars[navigationBarTitle]
        XCTAssert(navigationBar.exists, "The navigation bar does not exist")
    }
    
    override func tearDown() {
        application = nil
        super.tearDown()
    }
}
