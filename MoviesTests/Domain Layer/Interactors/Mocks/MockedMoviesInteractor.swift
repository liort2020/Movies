//
//  MockedMoviesInteractor.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
import SwiftUI
@testable import Movies

final class MockedMoviesInteractor: Mocking, MoviesInteractorProtocol {
    enum Action: Equatable {
        case load
        case fetchMovies(Int)
        case fetchMovie(Int)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var movies: [Movie] = []
    
    func load() async throws -> [Movie] {
        add(.load)
        return movies
    }
    
    func fetchMovies(page: Int) async throws -> [Movie] {
        add(.fetchMovies(page))
        return movies
    }
    
    func fetchMovie(id: Int) async throws -> [Movie] {
        add(.fetchMovie(id))
        return movies
    }
}
