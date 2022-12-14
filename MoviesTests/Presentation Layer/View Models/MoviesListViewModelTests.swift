//
//  MoviesListViewModelTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class MoviesListViewModelTests: XCTestCase {
    private lazy var mockedMoviesInteractor = MockedMoviesInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(interactors: .mocked(moviesInteractor: mockedMoviesInteractor))
    }()
    private lazy var fakeMovies = FakeMovies.all
    private lazy var isLoading = false
    
    var testableObject: MoviesListViewModel?
    
    override func setUp() {
        super.setUp()
        testableObject = MoviesListViewModel(moviesInteractor: diContainer.interactors?.moviesInteractor,
                                                 movies: fakeMovies,
                                                 isLoading: isLoading)
    }
    
    func test_load() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        // Given
        mockedMoviesInteractor.actions = MockedList(expectedActions: [
            .load
        ])
        
        // When
        await testableObject.load()
        
        // Then
        mockedMoviesInteractor.verify()
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
