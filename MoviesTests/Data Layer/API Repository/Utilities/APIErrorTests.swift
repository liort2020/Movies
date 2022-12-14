//
//  APIErrorTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class APIErrorTests: XCTestCase {
    private var testURL: URL?
    
    override func setUp() {
        super.setUp()
        testURL = URL(string: TestAPIRepository.testMoviesURL)
    }
    
    func test_badRequest() {
        XCTAssertEqual(HTTPError(code: 400), .badRequest)
    }
    
    func test_unauthorized() {
        XCTAssertEqual(HTTPError(code: 401), .unauthorized)
    }
    
    func test_notFound() {
        XCTAssertEqual(HTTPError(code: 404), .notFound)
    }
    
    func test_unprocessableRequest() {
        XCTAssertEqual(HTTPError(code: 422), .unprocessableRequest)
    }
    
    func test_serverError() {
        XCTAssertEqual(HTTPError(code: 500), .serverError)
    }
    
    func test_unknown() {
        XCTAssertEqual(HTTPError(code: 402), .unknown)
    }
    
    func test_isValidStatusCode() throws {
        let url = try XCTUnwrap(testURL)
        var statusCode = 200
        var response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil))
        XCTAssertTrue(response.isValidStatusCode())
        
        statusCode = 299
        response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil))
        XCTAssertTrue(response.isValidStatusCode())
    }
    
    func test_invalidStatusCode() throws {
        let url = try XCTUnwrap(testURL)
        var statusCode = 199
        var response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil))
        XCTAssertFalse(response.isValidStatusCode())
        
        statusCode = 300
        response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil))
        XCTAssertFalse(response.isValidStatusCode())
    }
    
    override func tearDown() {
        testURL = nil
        super.tearDown()
    }
}
