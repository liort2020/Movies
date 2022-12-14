//
//  MockedMovie.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

final class MockedMovie {
    static var testBundle = Bundle(for: MockedMovie.self)
    static let mockedMoviesFileName = "mock_movies"
    
    static func load<Model: Codable>(fromResource fileName: String) -> Model? {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func getMoviesData(fromResource fileName: String) -> Data? {
        guard let url = testBundle.url(forResource: fileName, withExtension: "json") else { return nil }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            print("An error occurred while loading a mock model: \(error.localizedDescription)")
            return nil
        }
    }
}
