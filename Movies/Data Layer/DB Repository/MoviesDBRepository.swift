//
//  MoviesDBRepository.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import Foundation

protocol MoviesDBRepositoryProtocol {
    func fetchMovies() async throws -> [Movie]
    func fetchMovie(id: Int) async throws -> [Movie]
    func store(moviesListAPI: MoviesListAPI, movieType: MovieType) async throws -> [Movie]
    func delete(movieId: Int) async throws
}

struct MoviesDBRepository: MoviesDBRepositoryProtocol {
    private let persistentStore: PersistentStore
    
    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
    }
    
    func fetchMovies() async throws -> [Movie] {
        let fetchRequest = Movie.requestAllItems()
        return try await persistentStore.fetch(fetchRequest)
    }
    
    func fetchMovie(id: Int) async throws -> [Movie] {
        let fetchRequest = Movie.requestItem(using: id)
        return try await persistentStore.fetch(fetchRequest)
    }
    
    func store(moviesListAPI: MoviesListAPI, movieType: MovieType) async throws -> [Movie] {
        var movies: [Movie] = []
        
        try await withThrowingTaskGroup(of: Movie.self) { group in
            moviesListAPI.movies?.forEach { model in
                group.addTask {
                    let fetchRequest = Movie.requestItem(using: model.id)
                    
                    return try await persistentStore
                        .update(fetchRequest: fetchRequest) { item in
                            item.type = movieType.rawValue
                            item.title = model.title
                            item.overview = model.overview
                            item.releaseDate = model.releaseDate
                            item.rating = model.rating ?? Constants.defaultMovieRating
                            item.posterPath = model.posterPath
                        } createNew: { context in
                            model.store(in: context, movieType: movieType)
                        }
                }
            }
            
            for try await movie in group {
                movies.append(movie)
            }
        }
        return movies
    }
    
    func delete(movieId: Int) async throws {
        let fetchRequest = Movie.requestItem(using: movieId)
        return try await persistentStore.delete(fetchRequest)
    }
}
