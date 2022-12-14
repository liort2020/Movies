//
//  ImageView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI
import URLImage

struct ImageView: View {
    var url: URL?
    let movieId: Int
    var width: CGFloat?
    var height: CGFloat?
    var contentMode: ContentMode = .fit
    
    var body: some View {
        HStack {
            if let url {
                URLImage(url: url,
                         options: urlImageOptions) {
                    emptyImageView()
                } inProgress: { progress in
                    ZStack {
                        emptyImageView()
                        ActivityIndicator()
                    }
                } failure: { error, retry in
                    emptyImageView()
                } content: { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                        .clipped()
                }
            } else {
                emptyImageView()
            }
        }
        .frame(width: width, height: height)
    }
    
    // MARK: Computed Properties
    private var id: String {
        "\(movieId)"
    }
    
    private var urlImageOptions: URLImageOptions {
        URLImageOptions(identifier: id,
                        expireAfter: expireAfter,
                        cachePolicy: .returnCacheElseLoad(cacheDelay: nil, downloadDelay: 0.25))
    }
    
    private func emptyImageView() -> some View {
        EmptyImageView(width: width, height: height, contentMode: contentMode)
    }
    
    // MARK: Constants
    private let expireAfter: TimeInterval = 24 * 60 * 60 // 86,400 second = 24 hours
}
