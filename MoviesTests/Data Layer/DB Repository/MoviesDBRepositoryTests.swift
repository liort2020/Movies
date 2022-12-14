//
//  MoviesDBRepositoryTests.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
import CoreData
@testable import Movies

final class MoviesDBRepositoryTests: XCTestCase {
    private var mockedPersistentStore = MockedPersistentStore()
    
    private var testableObject: MoviesDBRepository?
    
    // MARK: - setUp
    override func setUp() {
        super.setUp()
        mockedPersistentStore.inMemoryContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load store: \(error)")
            }
        }
        
        testableObject = MoviesDBRepository(persistentStore: mockedPersistentStore)
        mockedPersistentStore.verify()
    }
    
    func test_fetch_movies() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let moviesListAPI: MoviesListAPI = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        let movieAPIModel = try XCTUnwrap(moviesListAPI.movies)
        
        // Given
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot)
        ])
        
        // Save items
        save(items: movieAPIModel, in: context, movieType: .upcoming)
        
        do {
            // When
            // Fetch items
            let movies = try await testableObject.fetchMovies()
            // Then
            XCTAssertEqual(movieAPIModel.count, movies.count, "Fetch \(movies.count) items instead of \(movieAPIModel.count) items")
            self.mockedPersistentStore.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_store_moviesListAPI() async throws {
        let testableObject = try XCTUnwrap(testableObject)
        let moviesListAPI: MoviesListAPI = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        
        // Given
        let numberOfItems = 20
        let updateOneItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 1, updatedObjects: 0, deletedObjects: 0)
        let updateItemsSnapshot = Array(repeating: updateOneItemSnapshot, count: numberOfItems)
        let expectedActions = updateItemsSnapshot.map { MockedPersistentStore.Action.update($0) }
        mockedPersistentStore.actions = MockedList(expectedActions: expectedActions)
        
        do {
            // When
            let movies = try await testableObject.store(moviesListAPI: moviesListAPI, movieType: .upcoming)
            // Then
            XCTAssertEqual(numberOfItems, movies.count, "Store \(movies.count) items instead of \(numberOfItems) items")
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test_delete_movie() async throws {
        let context = mockedPersistentStore.inMemoryContainer.viewContext
        let moviesListAPI: MoviesListAPI = try XCTUnwrap(MockedMovie.load(fromResource: MockedMovie.mockedMoviesFileName))
        let movieAPIModel = try XCTUnwrap(moviesListAPI.movies)
        
        // Given
        let deleteItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 1)
        let fetchItemSnapshot = MockedPersistentStore.Snapshot(insertedObjects: 0, updatedObjects: 0, deletedObjects: 0)
        mockedPersistentStore.actions = MockedList(expectedActions: [
            .fetch(fetchItemSnapshot),
            .delete(deleteItemSnapshot),
            .fetch(fetchItemSnapshot)
        ])
        
        // Save items
        save(items: movieAPIModel, in: context, movieType: .upcoming)
        
        let testableObject = try XCTUnwrap(testableObject)
        
        var movieItemsBeforeDelete: [Movie] = []
        
        do {
            // When
            // Fetch items before delete
            let movies = try await testableObject.fetchMovies()
            // Delete item
            movieItemsBeforeDelete.append(contentsOf: movies)
            let movieItem = movieItemsBeforeDelete[0]
            let _ = try await testableObject.delete(movieId: Int(movieItem.id))
            // Fetch items after delete
            let movieItemsAfterDelete = try await testableObject.fetchMovies()
            // Then
            XCTAssertEqual(movieItemsBeforeDelete.count - 1, movieItemsAfterDelete.count, "Fetch \(movieItemsAfterDelete.count) items instead of \(movieItemsBeforeDelete.count - 1) items")
            mockedPersistentStore.verify()
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - tearDown
    override func tearDown() {
        testableObject = nil
        super.tearDown()
    }
}

// MARK: - save items for tests
fileprivate extension MoviesDBRepositoryTests {
    func save(items models: [some MovieAPI], in context: NSManagedObjectContext, movieType: MovieType) {
        context.performAndWait {
            do {
                models.forEach {
                    $0.store(in: context, movieType: movieType)
                }
                
                guard context.hasChanges else {
                    XCTFail("Items not saved")
                    context.reset()
                    return
                }
                try context.save()
            } catch {
                XCTFail("Items not saved")
                context.reset()
            }
        }
    }
}
