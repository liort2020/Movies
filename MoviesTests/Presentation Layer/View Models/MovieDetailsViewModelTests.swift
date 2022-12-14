//
//  MovieDetailsViewModelTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class MovieDetailsViewModelTests: XCTestCase {
    private lazy var mockedMoviesInteractor = MockedMoviesInteractor()
    private lazy var diContainer: DIContainer = {
        DIContainer.init(interactors: .mocked(moviesInteractor: mockedMoviesInteractor))
    }()
    private lazy var fakeMovie = FakeMovies.all[0]
    
    var testableObject: MovieDetailsViewModel?
    
    override func setUp() {
        super.setUp()
        testableObject = MovieDetailsViewModel(moviesInteractor: diContainer.interactors?.moviesInteractor,
                                               movie: fakeMovie)
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
