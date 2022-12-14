//
//  MoviesListViewModel+UserDefaults.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import Foundation

extension MoviesListViewModel {
    enum UserDefaultsKeys: String {
        case currentPage
    }
    
    private static var defaultCurrentPage = 1
    
    var currentPage: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.currentPage.rawValue)
        }
        get {
            // check if value exists
            guard UserDefaults.standard.object(forKey: UserDefaultsKeys.currentPage.rawValue) != nil else {
                // Set default value
                UserDefaults.standard.set(Self.defaultCurrentPage, forKey: UserDefaultsKeys.currentPage.rawValue)
                return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentPage.rawValue)
            }
            return UserDefaults.standard.integer(forKey: UserDefaultsKeys.currentPage.rawValue)
        }
    }
}
