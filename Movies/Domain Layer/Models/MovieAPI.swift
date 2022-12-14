//
//  MovieAPI.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import Foundation

protocol MovieAPI: Equatable {
    var id: Int { get }
    var title: String? { get }
    var overview: String? { get }
    var releaseDate: String? { get }
    var rating: Double? { get }
    var posterPath: String? { get }
}

enum MovieType: String {
    case upcoming
    case topRated
    case nowPlaying
}
