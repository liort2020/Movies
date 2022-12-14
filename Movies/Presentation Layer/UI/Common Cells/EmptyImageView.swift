//
//  EmptyImageView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct EmptyImageView: View {
    var width: CGFloat?
    var height: CGFloat?
    var contentMode: ContentMode = .fit
    
    var body: some View {
        HStack {
            if let emptyImage = UIImage(named: emptyImageName) {
                Image(uiImage: emptyImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .clipped()
            }
        }
        .frame(width: width, height: height)
    }
    
    // MARK: Constants
    private let emptyImageName = "empty_image.jpg"
}

// MARK: - Previews
struct EmptyImageView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyImageView(width: imageSize, height: imageSize)
            .previewLayout(.sizeThatFits)
    }
    
    // MARK: Preview Constants
    private static let imageSize: CGFloat = 130
}
