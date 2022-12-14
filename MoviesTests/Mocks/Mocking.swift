//
//  Mocking.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

protocol Mocking {
    associatedtype Action: Equatable
    var actions: MockedList<Action> { get }
    
    func add(_ action: Action)
    func verify()
}

extension Mocking {
    func add(_ action: Action) {
        actions.add(action)
    }
    
    func verify() {
        actions.verify()
    }
}

final class MockedList<Action: Equatable> {
    private let expectedActions: [Action]
    private var actualActions: [Action]
    
    init(expectedActions: [Action]) {
        self.expectedActions = expectedActions
        actualActions = []
    }
    
    func add(_ action: Action) {
        actualActions.append(action)
    }
    
    func verify() {
        XCTAssertEqual(actualActions, expectedActions, "Expected actions: \(expectedActions), Actual actions: \(actualActions)")
    }
}
