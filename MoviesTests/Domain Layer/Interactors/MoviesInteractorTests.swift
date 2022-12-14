//
//  MoviesInteractorTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
import CoreData
@testable import Movies

final class MoviesInteractorTests: XCTestCase {
    private lazy var mockedMoviesAPIRepository = MockedMoviesAPIRepository()
    private lazy var mockedMoviesDBRepository = MockedMoviesDBRepository()
    private lazy var fakeMovies = FakeMovies.all
    
    var testableObject: MoviesInteractor?
    
    override func setUp() {
        super.setUp()
        testableObject = MoviesInteractor(moviesAPIRepository: mockedMoviesAPIRepository,
                                          moviesDBRepository: mockedMoviesDBRepository)
    }
    
    func test_load() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        mockedMoviesAPIRepository.actions = MockedList(expectedActions: [])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .fetchMovies
        ])
        
        // Set DBRepository response
        mockedMoviesDBRepository.movies = fakeMovies
        
        do {
            // When
            let movies = try await testableObject.load()
            
            // Then
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.count, self.fakeMovies.count, "Receive \(movies.count) items instead of \(self.fakeMovies.count) items")
            self.mockedMoviesAPIRepository.verify()
            self.mockedMoviesDBRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_fetchAll() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let page = 1
        mockedMoviesAPIRepository.actions = MockedList(expectedActions: [
            .getMovies(movieType: .upcoming, page: page),
            .getMovies(movieType: .topRated, page: page),
            .getMovies(movieType: .nowPlaying, page: page)
        ])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .fetchMovies
        ])
        
        // Set MoviesAPIRepository response
        let moviesListAPI: MoviesListAPI = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        mockedMoviesAPIRepository.moviesListAPI = moviesListAPI
        
        // Set DBRepository response
        mockedMoviesDBRepository.movies = fakeMovies
        
        do {
            // When
            let movies = try await testableObject.fetchMovies(page: page)
            
            // Then
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.count, self.fakeMovies.count, "Receive \(movies.count) items instead of \(self.fakeMovies.count) items")
            self.mockedMoviesAPIRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_fetchMovie() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        
        // Given
        let movieId = 436969
        let onlyOneFakeMovie = [try XCTUnwrap(fakeMovies.first)]
        mockedMoviesAPIRepository.actions = MockedList(expectedActions: [])
        mockedMoviesDBRepository.actions = MockedList(expectedActions: [
            .fetchMovie(id: movieId)
        ])
        
        // Set MoviesAPIRepository response
        let moviesListAPI: MoviesListAPI = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        mockedMoviesAPIRepository.moviesListAPI = moviesListAPI
        
        // Set DBRepository response
        mockedMoviesDBRepository.movies = onlyOneFakeMovie
        
        do {
            // When
            let movies = try await testableObject.fetchMovie(id: movieId)
            
            // Then
            XCTAssertFalse(movies.isEmpty)
            XCTAssertEqual(movies.count, onlyOneFakeMovie.count, "Receive \(movies.count) items instead of \(onlyOneFakeMovie.count) items")
            self.mockedMoviesAPIRepository.verify()
            self.mockedMoviesDBRepository.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}
