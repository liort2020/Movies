//
//  AppState.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

final class AppState: ObservableObject {
    @Published var viewRouting = ViewRouting()
}
