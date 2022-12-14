//
//  MoviesListViewModel.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

protocol MoviesListViewModelProtocol: ObservableObject {
    var movies: [Movie] { get set }
    var isLoading: Bool { get set }
    var moviesInteractor: MoviesInteractorProtocol? { get }
    
    func load() async
    func fetchMovies(enableIsLoading: Bool) async
}

enum FilterType: String, CaseIterable {
    case none
    case upcoming
    case topRated
    case nowPlaying
}

class MoviesListViewModel: MoviesListViewModelProtocol {
    @Published var movies: [Movie]
    @Published var isLoading: Bool
    private(set) var moviesInteractor: MoviesInteractorProtocol?
    
    init(moviesInteractor: MoviesInteractorProtocol?, movies: [Movie] = [], isLoading: Bool = true) {
        self.moviesInteractor = moviesInteractor
        self.movies = movies
        self.isLoading = isLoading
    }
    
    func load() async {
        guard let moviesInteractor else { return }
        
        await isLoading(true)
        
        do {
            let allMovies = try await moviesInteractor.load()
            await update(allMovies: allMovies)
        } catch {
            print("An error occurred while loading: \(error.localizedDescription)")
            await isLoading(false)
        }
    }
    
    func fetchMovies(enableIsLoading: Bool) async {
        guard let moviesInteractor else { return }
        
        if enableIsLoading {
            await isLoading(true)
        }
        
        do {
            let movies = try await moviesInteractor.fetchMovies(page: currentPage)
            self.currentPage += 1
            await self.update(movies: movies, enableIsLoading: enableIsLoading)
        } catch {
            print("An error occurred while loading: \(error.localizedDescription)")
            await isLoading(false)
        }
    }
    
    // MARK: Update UI
    @MainActor
    private func update(movies: [Movie], enableIsLoading: Bool) {
        let newMovies = movies.filter {
            !self.movies.map { $0.id }.contains($0.id)
        }
        self.movies.append(contentsOf: newMovies)
        
        if enableIsLoading {
            isLoading(false)
        }
    }
    
    @MainActor
    private func update(allMovies movies: [Movie]) {
        self.movies = movies
        isLoading(false)
    }
    
    @MainActor
    private func isLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
}
