//
//  Movie+FetchRequest.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import CoreData

extension Movie {
    static let entityName = "Movie"
    
    static func requestAllItems() -> NSFetchRequest<Movie> {
        NSFetchRequest<Movie>(entityName: entityName)
    }
    
    static func requestItem(using id: Int) -> NSFetchRequest<Movie> {
        let request = NSFetchRequest<Movie>(entityName: entityName)
        request.predicate = NSPredicate(format: "id == %i", Int32(id))
        return request
    }
}

// MARK: - Store
extension MovieAPI {
    @discardableResult
    func store(in context: NSManagedObjectContext, movieType: MovieType) -> Movie {
        let baseModel = Movie(context: context)
        baseModel.id = Int32(id)
        baseModel.type = movieType.rawValue
        baseModel.title = title
        baseModel.overview = overview
        baseModel.releaseDate = releaseDate
        baseModel.rating = rating ?? Constants.defaultMovieRating
        baseModel.posterPath = posterPath
        return baseModel
    }
}
