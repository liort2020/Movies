//
//  ViewRouting.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

final class ViewRouting: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showMoviesFilterSheet: Bool = false
}
