//
//  FilterButtonView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct FilterButtonView: View {
    @Binding var showMoviesFilterSheet: Bool
    
    var body: some View {
        Button(action: {
            showMoviesFilterSheet = true
        }) {
            Image(systemName: filterButtonSystemImage)
                .resizable()
                .foregroundColor(filterButtonColor)
        }
    }
    
    // MARK: Constants
    private let filterButtonSystemImage = "line.horizontal.3.decrease.circle"
    private let filterButtonColor: Color = .primary
}

// MARK: - Previews
struct FilterButtonView_Previews: PreviewProvider {
    private static let showMoviesFilterSheet = Binding.constant(false)
    
    static var previews: some View {
        FilterButtonView(showMoviesFilterSheet: showMoviesFilterSheet)
            .frame(maxWidth: cellSize.width, maxHeight: cellSize.height)
            .previewLayout(.sizeThatFits)
    }
    
    // MARK: Preview Constants
    private static let cellSize: CGSize = CGSize(width: 30, height: 30)
}
