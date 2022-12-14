//
//  MockedMovieDetailsViewModel.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class MockedMovieDetailsViewModel: Mocking, MovieDetailsViewModelProtocol {
    // MARK: MovieDetailsViewModelProtocol
    var moviesInteractor: MoviesInteractorProtocol?
    var movie: Movie
    
    enum Action: Equatable {
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    init(moviesInteractor: MoviesInteractorProtocol?, movie: Movie) {
        self.moviesInteractor = moviesInteractor
        self.movie = movie
    }
}
