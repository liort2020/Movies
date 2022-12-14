//
//  MovieDetailsViewModel.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

protocol MovieDetailsViewModelProtocol: ObservableObject {
    var moviesInteractor: MoviesInteractorProtocol? { get }
    var movie: Movie { get set }
}

class MovieDetailsViewModel: MovieDetailsViewModelProtocol {
    @Published var movie: Movie
    private(set) var moviesInteractor: MoviesInteractorProtocol?
    
    init(moviesInteractor: MoviesInteractorProtocol?, movie: Movie) {
        self.moviesInteractor = moviesInteractor
        self.movie = movie
    }
}
