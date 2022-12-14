//
//  DIContainer.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct DIContainer {
    private(set) var interactors: Interactors?
    
    static func boot() -> DIContainer {
        let session = URLSession.shared
        let apiRepositories = configureAPIRepositories(using: session)
        let dbRepositories = configureDBRepositories()
        let interactors = configureInteractors(apiRepositories: apiRepositories, dbRepositories: dbRepositories)
        
        return DIContainer(interactors: interactors)
    }
    
    private static func configureAPIRepositories(using session: URLSession) -> DIContainer.APIRepositories {
        let moviesAPIRepository = MoviesAPIRepository(session: session, baseURL: Constants.baseMoviesUrl)
        return DIContainer.APIRepositories(moviesAPIRepository: moviesAPIRepository)
    }
    
    private static func configureDBRepositories() -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack()
        let moviesDBRepository = MoviesDBRepository(persistentStore: persistentStore)
        return DIContainer.DBRepositories(moviesDBRepository: moviesDBRepository)
    }
    
    private static func configureInteractors(apiRepositories: DIContainer.APIRepositories, dbRepositories: DIContainer.DBRepositories) -> DIContainer.Interactors {
        let moviesAPIRepository: MoviesAPIRepositoryProtocol = apiRepositories.moviesAPIRepository
        
        let moviesInteractor = MoviesInteractor(moviesAPIRepository: moviesAPIRepository,
                                                moviesDBRepository: dbRepositories.moviesDBRepository)
        return DIContainer.Interactors(moviesInteractor: moviesInteractor)
    }
}
