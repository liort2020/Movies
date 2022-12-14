//
//  EmptyTextView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct EmptyTextView: View {
    var emptyTitle: String
    
    var body: some View {
        Text(emptyTitle)
            .foregroundColor(emptyTitleColor)
            .font(emptyTitleFont)
    }
    
    // MARK: Constants
    private let emptyTitleColor: Color = .secondary
    private let emptyTitleFont: Font = .system(size: 20)
}

// MARK: - Previews
struct EmptyTextView_Previews: PreviewProvider {
    private static let emptyListTitle = "No Data Available"
    
    static var previews: some View {
        EmptyTextView(emptyTitle: emptyListTitle)
            .previewLayout(.sizeThatFits)
    }
}
