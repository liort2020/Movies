//
//  MovieDetailsView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct MovieDetailsView<ViewModel: MovieDetailsViewModelProtocol>: View {
    @ObservedObject var movieDetailsViewModel: ViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    // MARK: Image
                    ImageView(url: imageURL,
                              movieId: movieId,
                              height: defaultBlurImageSize,
                              contentMode: blurImageContentMode)
                    .edgesIgnoringSafeArea(.all)
                    .blur(radius: blurRadius)
                    
                    HStack {
                        Spacer()
                        ImageView(url: imageURL,
                                  movieId: movieId,
                                  width: defaultMovieImageWidth,
                                  height: defaultMovieImageHeight,
                                  contentMode: blurImageContentMode)
                        Spacer()
                    }
                    
                    // MARK: Movie type cell
                    VStack {
                        HStack {
                            Spacer()
                            MovieTypeCell(movieType: movieDetailsViewModel.movie.type)
                        }
                        Spacer()
                    }
                }
                
                // MARK: Movie details
                VStack(alignment: .leading) {
                    Text(movieDetailsViewModel.movie.title ?? defaultEmptyTitle)
                        .font(titleFont)
                        .foregroundColor(titleColor)
                        .padding(.top, topTitlePadding)
                    
                    HStack(spacing: spacingRatingCellAndMovieYear) {
                        RatingCell(movieRating: movieDetailsViewModel.movie.rating)
                        
                        HStack {
                            Text(movieYear)
                                .font(yearTitleFont)
                                .foregroundColor(yearTitleColor)
                        }
                        
                        Spacer()
                    }
                    
                    Text(movieDetailsViewModel.movie.overview ?? defaultEmptyTitle)
                        .font(storylineFont)
                        .foregroundColor(storylineColor)
                        .padding(.top, topStorylinePadding)
                }
                .padding(.bottom, movieDetailsBottomPadding)
            }
            .padding()
        }
    }
    
    // MARK: Computed Properties
    private var movieId: Int {
        Int(movieDetailsViewModel.movie.id)
    }
    
    private var imageURL: URL? {
        let baseImageURL = Constants.baseImagesUrl
        guard let posterPath = movieDetailsViewModel.movie.posterPath else { return nil }
        return URL(string: baseImageURL + posterPath)
    }
    
    private var movieYear: String {
        movieDetailsViewModel.movie.releaseDate?.getMovieYear() ?? defaultEmptyTitle
    }
    
    // MARK: Constants
    private let spacingRatingCellAndMovieYear: CGFloat = 10
    // Blur
    private let blurRadius: CGFloat = 50.0
    private let blurImageContentMode: ContentMode = .fill
    private let defaultBlurImageSize: CGFloat = 250
    // Movie image
    private let defaultMovieImageWidth: CGFloat = 150
    private let defaultMovieImageHeight: CGFloat = 250
    // Title
    private let titleColor: Color = .primary
    private let titleFont: Font = .system(size: 26, weight: .bold)
    private let topTitlePadding: CGFloat = 4
    // Storyline
    private let storylineColor: Color = .primary
    private let storylineFont: Font = .system(size: 16, weight: .regular)
    private let topStorylinePadding: CGFloat = 12
    private let defaultEmptyTitle = ""
    // Movie details
    private let movieDetailsBottomPadding: CGFloat = 8
    // Movie Year Title
    private let yearTitleColor: Color = .primary
    private let yearTitleFont: Font = .system(size: 17, weight: .medium)
}

// MARK: - Previews
struct MovieDetailsView_Previews: PreviewProvider {
    private static let appState = AppState()
    private static let moviesInteractor = DIContainer().interactors?.moviesInteractor
    private static let movieDetailsViewModel = MovieDetailsViewModel(moviesInteractor: moviesInteractor, movie: FakeMovies.all[0])
    
    static var previews: some View {
        MovieDetailsView(movieDetailsViewModel: movieDetailsViewModel)
            .appState(appState)
    }
}
