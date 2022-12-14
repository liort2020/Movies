//
//  MoviesListAPI.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import Foundation

struct MoviesListAPI: Codable, Equatable {
    let movies: [BaseMovieAPI]?
    
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct BaseMovieAPI: Codable, MovieAPI {
    let id: Int
    let title: String?
    let overview: String?
    let releaseDate: String?
    let rating: Double?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
    }
}

/*
 {
   "page": 1,
   "results": [
     {
       "adult": false,
       "backdrop_path": "/tmU7GeKVybMWFButWEGl2M4GeiP.jpg",
       "genre_ids": [
         18,
         80
       ],
       "id": 238,
       "original_language": "en",
       "original_title": "The Godfather",
       "overview": "Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.",
       "popularity": 88.994,
       "poster_path": "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg",
       "release_date": "1972-03-14",
       "title": "The Godfather",
       "video": false,
       "vote_average": 8.7,
       "vote_count": 17053
     }
   ],
   "total_pages": 530,
   "total_results": 10581
 }
 */
