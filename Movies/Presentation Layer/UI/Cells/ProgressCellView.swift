//
//  ProgressCellView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct ProgressCellView: View {
    @State private var showProgressCell = true
    private let timer = Timer.publish(every: Self.timeInSeconds, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack {
            if showProgressCell {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
        .onReceive(timer) { _ in
            showProgressCell = false
            timer.upstream.connect().cancel()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
    
    // MARK: Constants
    private static let timeInSeconds: TimeInterval = 5
}

// MARK: - Previews
struct ProgressCellView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCellView()
            .previewLayout(.sizeThatFits)
    }
}
