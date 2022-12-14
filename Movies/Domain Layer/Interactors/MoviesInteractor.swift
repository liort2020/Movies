//
//  MoviesInteractor.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

protocol MoviesInteractorProtocol {
    func load() async throws -> [Movie]
    func fetchMovies(page: Int) async throws -> [Movie]
    func fetchMovie(id: Int) async throws -> [Movie]
}

class MoviesInteractor: MoviesInteractorProtocol {
    private let moviesAPIRepository: MoviesAPIRepositoryProtocol
    private let moviesDBRepository: MoviesDBRepositoryProtocol
    
    init(moviesAPIRepository: MoviesAPIRepositoryProtocol, moviesDBRepository: MoviesDBRepositoryProtocol) {
        self.moviesAPIRepository = moviesAPIRepository
        self.moviesDBRepository = moviesDBRepository
    }
    
    func load() async throws -> [Movie] {
        try await moviesDBRepository.fetchMovies()
    }
    
    func fetchMovies(page: Int) async throws -> [Movie] {
        // Fetch movies
        async let upcomingMoviesAPI = moviesAPIRepository.getMovies(by: .upcoming, page: page)
        async let topRatedMoviesAPI = moviesAPIRepository.getMovies(by: .topRated, page: page)
        async let nowPlayingMoviesAPI = moviesAPIRepository.getMovies(by: .nowPlaying, page: page)
        
        // Save to database
        let _ = try await moviesDBRepository.store(moviesListAPI: upcomingMoviesAPI, movieType: .upcoming)
        let _ = try await moviesDBRepository.store(moviesListAPI: topRatedMoviesAPI, movieType: .topRated)
        let _ = try await moviesDBRepository.store(moviesListAPI: nowPlayingMoviesAPI, movieType: .nowPlaying)
        return try await load()
    }
    
    func fetchMovie(id: Int) async throws -> [Movie] {
        try await moviesDBRepository.fetchMovie(id: id)
    }
}
