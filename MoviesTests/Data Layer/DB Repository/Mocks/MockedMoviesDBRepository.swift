//
//  MockedMoviesDBRepository.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
@testable import Movies

final class MockedMoviesDBRepository: Mocking, MoviesDBRepositoryProtocol {
    enum Action: Equatable {
        case fetchMovies
        case fetchMovie(id: Int)
        case store(moviesListAPI: MoviesListAPI, movieType: MovieType)
        case delete(movieId: Int)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var movies: [Movie] = []
    
    func fetchMovies() async throws -> [Movie] {
        add(.fetchMovies)
        return movies
    }
    
    func fetchMovie(id: Int) async throws -> [Movie] {
        add(.fetchMovie(id: id))
        return movies
    }
    
    func store(moviesListAPI: MoviesListAPI, movieType: MovieType) async throws -> [Movie] {
        add(.store(moviesListAPI: moviesListAPI, movieType: movieType))
        return movies
    }
    
    func delete(movieId: Int) async throws {
        add(.delete(movieId: movieId))
    }
}
