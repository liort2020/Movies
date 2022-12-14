//
//  MoviesListView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct MoviesListView<ViewModel: MoviesListViewModelProtocol>: View {
    @ObservedObject var moviesListViewModel: ViewModel
    @Environment(\.inject) var diContainer: DIContainer
    @EnvironmentObject var appState: AppState
    @State private var selectedFilters: [Bool] = [true, false, false, false]
    @State private var isFirstLoad = true
    
    var body: some View {
        NavigationStack(path: $appState.viewRouting.path) {
            Group {
                if isMovieListLoaded && !isFilteredMoviesListEmpty {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: cellSpacing) {
                            ForEach(filteredMovies, id: \.id) { movie in
                                NavigationLink(value: movie) {
                                    movieCellView(movie: movie)
                                }
                                
                                // MARK: Pagination cell
                                if filteredMovies.last == movie {
                                    ProgressCellView()
                                        .task {
                                            await fetchMovies(enableIsLoading: false)
                                        }
                                }
                            }
                        }
                        .padding(.top, topLazyVStackPadding)
                    }
                } else if isMovieListEmpty {
                    VStack {
                        Spacer()
                        EmptyTextView(emptyTitle: emptyListTitle)
                            .padding(.bottom, bottomEmptyCellViewPadding)
                        Spacer()
                    }
                } else if isFilteredMoviesListLoadedAndEmpty {
                    VStack {
                        Spacer()
                        EmptyTextView(emptyTitle: emptyFilterTitle)
                            .padding(.bottom, bottomEmptyCellViewPadding)
                        Spacer()
                    }
                } else {
                    EmptyView()
                }
            }
            .navigationDestination(for: Movie.self, destination: { movie in
                movieDetailsView(movie: movie)
            })
            .appState(appState)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navigationBarTitle)
            .navigationBarItems(trailing: filterButtonView())
        }
        .sheet(isPresented: showMoviesFilterSheet) {
            MoviesFilterView(selectedFilters: $selectedFilters, showMoviesFilterSheet: showMoviesFilterSheet)
        }
        .task {
            if isFirstLoad {
                await fetchMovies()
            }
            isFirstLoad = false
        }
    }
    
    // MARK: Computed Properties
    private var movies: [Movie] {
        moviesListViewModel.movies
    }
    
    private var moviesInteractor: MoviesInteractorProtocol? {
        moviesListViewModel.moviesInteractor
    }
    
    private var isMovieListLoaded: Bool {
        !moviesListViewModel.isLoading && !movies.isEmpty
    }
    
    private var isMovieListEmpty: Bool {
        !moviesListViewModel.isLoading && movies.isEmpty
    }
    
    private var isFilteredMoviesListLoadedAndEmpty: Bool {
        !moviesListViewModel.isLoading && filteredMovies.isEmpty
    }
    
    private var isFilteredMoviesListEmpty: Bool {
        filteredMovies.isEmpty
    }
    
    private func filterButtonView() -> some View {
        FilterButtonView(showMoviesFilterSheet: showMoviesFilterSheet)
    }
    
    private var showMoviesFilterSheet: Binding<Bool> {
        $appState.viewRouting.showMoviesFilterSheet
    }
    
    // MARK: Constants
    private let topLazyVStackPadding: CGFloat = 10
    // Cell
    private let cellSpacing: CGFloat = 6
    private let horizontalCellPadding: CGFloat = 8
    private let cellShadowRadius: CGFloat = 2
    private let cellCornerRadius: CGFloat = 6
    private let cellBackgroundColor = Color(UIColor.systemBackground)
    // Empty Cell
    private let bottomEmptyCellViewPadding: CGFloat = 150
    private let emptyListTitle = "No Data Available"
    private let emptyFilterTitle = "No Data Found"
    // Navigation
    private let navigationBarTitle = "Movies"
}

// MARK: - Actions
extension MoviesListView {
    private func fetchMovies() async {
        await moviesListViewModel.load()
        await moviesListViewModel.fetchMovies(enableIsLoading: true)
    }
}

// MARK: - Navigation
extension MoviesListView {
    private func movieDetailsView(movie: Movie) -> some View {
        MovieDetailsView(movieDetailsViewModel: MovieDetailsViewModel(moviesInteractor: moviesInteractor, movie: movie))
            .appState(appState)
    }
    
    private func movieCellView(movie: Movie) -> some View {
        MovieCellView(movie: movie)
            .background(cellBackgroundColor)
            .cornerRadius(cellCornerRadius)
            .padding(.horizontal, horizontalCellPadding)
            .shadow(radius: cellShadowRadius)
    }
}

// MARK: - Actions
extension MoviesListView {
    private func fetchMovies(enableIsLoading: Bool) async {
        await moviesListViewModel.fetchMovies(enableIsLoading: enableIsLoading)
    }
}

// MARK: - Filter
extension MoviesListView {
    var filteredMovies: [Movie] {
        let selectedFilterIndex = selectedFilters.enumerated().first { $1 }.map { $0.0 }
        guard let selectedFilterIndex else { return movies }
        let filter = FilterType.allCases[selectedFilterIndex]
        
        switch filter {
        case .none:
            return movies
        case .upcoming:
            return movies.filter { $0.type == MovieType.upcoming.rawValue }
        case .topRated:
            return movies.filter { $0.type == MovieType.topRated.rawValue }
        case .nowPlaying:
            return movies.filter { $0.type == MovieType.nowPlaying.rawValue }
        }
    }
}

// MARK: - Previews
struct MoviesListView_Previews: PreviewProvider {
    private static let diContainer = DIContainer()
    private static let appState = AppState()
    private static let moviesInteractor = diContainer.interactors?.moviesInteractor
    private static let fakeMoviesListViewModel = MoviesListViewModel(moviesInteractor: moviesInteractor, movies: FakeMovies.all, isLoading: false)
    private static let fakeEmptyListViewModel = MoviesListViewModel(moviesInteractor: moviesInteractor, isLoading: false)
    
    static var previews: some View {
        Group {
            // MARK: With movies
            MoviesListView<MoviesListViewModel>(moviesListViewModel: fakeMoviesListViewModel)
                .inject(diContainer)
                .appState(appState)
            
            // MARK: Without movies
            MoviesListView<MoviesListViewModel>(moviesListViewModel: fakeEmptyListViewModel)
                .inject(diContainer)
                .appState(appState)
        }
    }
}
