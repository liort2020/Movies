//
//  MovieCellView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct MovieCellView: View {
    var movie: Movie
    
    var body: some View {
        ZStack {
            HStack {
                ImageView(url: imageURL,
                          movieId: movieId,
                          width: defaultImageSize,
                          height: defaultImageSize)
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text(movie.title ?? defaultEmptyTitle)
                        .lineLimit(titleNumberOfLines)
                        .font(titleFont)
                        .foregroundColor(titleColor)
                        .padding(.top, topTitlePadding)
                    
                    Spacer()
                    
                    HStack(spacing: spacingRatingCellAndMovieYear) {
                        RatingCell(movieRating: movie.rating)
                        
                        HStack {
                            Text(movieYear)
                                .font(yearTitleFont)
                                .foregroundColor(yearTitleColor)
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.leading, leadingContainerPadding)
                
                Spacer()
            }
            
            // Movie type cell
            VStack {
                HStack {
                    Spacer()
                    MovieTypeCell(movieType: movie.type)
                }
                Spacer()
            }
        }
    }
    
    // MARK: Computed Properties
    private var movieId: Int {
        Int(movie.id)
    }
    
    private var imageURL: URL? {
        let baseImageURL = Constants.baseImagesUrl
        guard let posterPath = movie.posterPath else { return nil }
        return URL(string: baseImageURL + posterPath)
    }
    
    private var movieYear: String {
        movie.releaseDate?.getMovieYear() ?? defaultEmptyTitle
    }
    
    // MARK: Constants
    private let leadingContainerPadding: CGFloat = 2
    private let spacingRatingCellAndMovieYear: CGFloat = 10
    // Image
    private let defaultImageSize: CGFloat = 130
    // Title
    private let titleColor: Color = .primary
    private let titleFont: Font = .system(size: 18, weight: .bold)
    private let topTitlePadding: CGFloat = 4
    private let titleNumberOfLines = 2
    private let defaultEmptyTitle = ""
    // Movie Year Title
    private let yearTitleColor: Color = .primary
    private let yearTitleFont: Font = .system(size: 17, weight: .medium)
}

// MARK: - Previews
struct MovieCellView_Previews: PreviewProvider {
    private static let movie = FakeMovies.all.first ?? Movie()
    
    static var previews: some View {
        MovieCellView(movie: movie)
            .frame(maxWidth: cellSize.width, maxHeight: cellSize.height)
            .previewLayout(.sizeThatFits)
    }
    
    // MARK: Preview Constants
    private static let cellSize: CGSize = CGSize(width: 440, height: 130)
}
