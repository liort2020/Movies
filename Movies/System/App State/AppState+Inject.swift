//
//  AppState+Inject.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

extension View {
    func appState(_ appState: AppState) -> some View {
        environmentObject(appState)
    }
}
