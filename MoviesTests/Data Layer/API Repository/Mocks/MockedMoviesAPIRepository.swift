//
//  MockedMoviesAPIRepository.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

enum APIRepositoryError: Error {
    case invalidModel
}

final class MockedMoviesAPIRepository: TestAPIRepository, Mocking, MoviesAPIRepositoryProtocol {
    enum Action: Equatable {
        case getMovies(movieType: MovieType, page: Int)
    }
    var actions = MockedList<Action>(expectedActions: [])
    
    var moviesListAPI: MoviesListAPI?
    
    func getMovies(by movieType: MovieType, page: Int) async throws -> MoviesListAPI {
        add(.getMovies(movieType: movieType, page: page))
        
        guard let moviesListAPI else { throw APIRepositoryError.invalidModel }
        return moviesListAPI
    }
}
