//
//  DIContainer+Inject.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

extension DIContainer: EnvironmentKey {
    static let defaultValue = DIContainer()
}

extension EnvironmentValues {
    var inject: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }
}

extension View {
    func inject(_ diContainer: DIContainer) -> some View {
        environment(\.inject, diContainer)
    }
}
