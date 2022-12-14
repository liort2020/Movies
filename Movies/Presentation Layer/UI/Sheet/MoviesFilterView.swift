//
//  MoviesFilterView.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import SwiftUI

struct MoviesFilterView: View {
    @Binding var selectedFilters: [Bool]
    @Binding var showMoviesFilterSheet: Bool
    private let filterTypes = FilterType.allCases
    
    var body: some View {
        NavigationView {
            List(filterTypes.indices, id: \.self) { index in
                CheckView(isChecked: $selectedFilters[index],
                          selectedFilters: $selectedFilters,
                          title: filterTypes[index].rawValue,
                          index: index)
            }
            .navigationBarItems(trailing: doneButtonView())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(navigationFilterViewTitle)
        }
    }
    
    private func doneButtonView() -> some View {
        Button(action: {
            showMoviesFilterSheet = false
        }) {
            Text(doneButtontitle)
        }
    }
    
    // MARK: Constants
    private let navigationFilterViewTitle = "Filter"
    private let titleFont: Font = .system(size: 16, weight: .regular)
    // Done Button
    private let doneButtontitle = "Done"
}

// MARK: - Previews
struct MoviesFilterView_Previews: PreviewProvider {
    private static let showMoviesFilterSheet = Binding.constant(true)
    private static let selectedFilters = Binding.constant([true, false, false, false])
    
    static var previews: some View {
        MoviesFilterView(selectedFilters: selectedFilters,
                         showMoviesFilterSheet: showMoviesFilterSheet)
    }
}
