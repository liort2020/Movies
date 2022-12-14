//
//  CoreDataStackTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class CoreDataStackTests: XCTestCase {
    private var testableObject: CoreDataStack?
    
    override func setUp() {
        super.setUp()
        testableObject = CoreDataStack()
    }
    
    func test_fetch() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let fetchRequest = Movie.requestAllItems()
        
        do {
            // When
            let _ = try await testableObject.fetch(fetchRequest)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_delete() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let testItemId = Int32.random(in: 1..<Int32.max)
        let fetchRequest = Movie.requestItem(using: Int(testItemId))
        
        do {
            // When
            let _ = try await testableObject.delete(fetchRequest)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
