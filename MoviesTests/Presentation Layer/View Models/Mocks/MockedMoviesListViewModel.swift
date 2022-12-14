//
//  MockedMoviesListViewModel.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class MockedMoviesListViewModel: Mocking, MoviesListViewModelProtocol {
    // MARK: MoviesListViewModelProtocol
    var moviesInteractor: MoviesInteractorProtocol?
    var movies: [Movie]
    var isLoading: Bool
    
    enum Action: Equatable {
        case load
        case fetchMovies(enableIsLoading: Bool)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    init(moviesInteractor: MoviesInteractorProtocol?, movies: [Movie] = [], isLoading: Bool = false) {
        self.moviesInteractor = moviesInteractor
        self.movies = movies
        self.isLoading = isLoading
    }
    
    func load() {
        add(.load)
    }
    
    func fetchMovies(enableIsLoading: Bool) {
        add(.fetchMovies(enableIsLoading: enableIsLoading))
    }
}
