//
//  MoviesApp.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

@main
struct MoviesApp: App {
    @StateObject private var appState = AppState()
    private static let diContainer = DIContainer.boot()
    private let moviesListViewModel = MoviesListViewModel(moviesInteractor: diContainer.interactors?.moviesInteractor)
    
    var body: some Scene {
        WindowGroup {
            MoviesListView<MoviesListViewModel>(moviesListViewModel: moviesListViewModel)
                .inject(Self.diContainer)
                .appState(appState)
        }
    }
}
