//
//  MoviesAPIRepository.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import Foundation

protocol MoviesAPIRepositoryProtocol: APIRepository {
    func getMovies(by movieType: MovieType, page: Int) async throws -> MoviesListAPI
}

class MoviesAPIRepository: MoviesAPIRepositoryProtocol {
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getMovies(by movieType: MovieType, page: Int) async throws -> MoviesListAPI {
        var endpoint: MoviesEndpoint
        
        switch movieType {
        case .upcoming:
            endpoint = MoviesEndpoint.getUpcomingMovies
        case .topRated:
            endpoint = MoviesEndpoint.getTopRatedMovies
        case .nowPlaying:
            endpoint = MoviesEndpoint.getNowPlayingMovies
        }
        
        return try await get(endpoint: endpoint, page: page)
    }
}
