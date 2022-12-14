//
//  RatingCell.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct RatingCell: View {
    var movieRating: Double
    
    var body: some View {
        Label {
            Text(rating)
                .lineLimit(numberOfLines)
                .font(textFont)
                .foregroundColor(textColor)
        } icon: {
            Image(systemName: starSystemImage)
                .resizable()
                .foregroundColor(starImageColor)
                .frame(width: defaultStarImageSize, height: defaultStarImageSize)
        }
    }
    
    // MARK: Computed Properties
    private var rating: String {
        String(format:"%.1f", movieRating)
    }
    
    // MARK: Constants
    // Star Image
    private let starSystemImage = "star.fill"
    private let starImageColor: Color = .yellow
    private let defaultStarImageSize: CGFloat = 18
    // Text
    private let textColor: Color = .primary
    private let textFont: Font = .system(size: 17, weight: .medium)
    private let numberOfLines = 1
}

// MARK: - Previews
struct RatingCell_Previews: PreviewProvider {
    private static let movieRating = 8.4
    
    static var previews: some View {
        RatingCell(movieRating: movieRating)
            .previewLayout(.sizeThatFits)
    }
}
