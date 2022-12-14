# Movies
![Application version](https://img.shields.io/badge/application%20version-v1.0.0-blue)
![Swift version](https://img.shields.io/badge/Swift-5.7-orange)
![Xcode version](https://img.shields.io/badge/Xcode-14.2-yellow)
![Platforms](https://img.shields.io/badge/platforms-iOS-lightgrey)


Movies is an application that shows movie details.

## Architecture

![Screenshot](https://github.com/liort2020/Movies/blob/master/Assets/MoviesArchitecture.png)

This application is implemented in Clean architecture and MVVM with three layers:
- **Presentation layer**
  - Contains `Views` and cells.
  - `MoviesListViewModel` - Connect between presentation layer and domain layer. `MoviesListViewModel` and `MockedMoviesListViewModel` (For Tests) implement `MoviesListViewModelProtocol` protocol (Strategy design pattern).
  - `MovieDetailsViewModel` - Connect between presentation layer and domain layer. `MovieDetailsViewModel` and `MockedMovieDetailsViewModel` (For Tests) implement `MovieDetailsViewModelProtocol` protocol (Strategy design pattern).
  - `ViewRouting` - Control navigation between views using NavigationPath.
  
- **Domain layer**
  - `MoviesInteractor` - Connect between presentation layer and data layer. `MoviesInteractor` and `MockedMoviesInteractor` (For Tests) implement `MoviesInteractorProtocol` protocol (Strategy design pattern).
  - `MoviesListAPI`- Model that we got from the server, implements `MovieAPI` and `Codable`.
  
- **Data Layer**
  - **APIRepositories**:
  - `APIRepository` - Retrieves data from the server using URLSession.
  - `MoviesAPIRepository` - Allow us to communicate with the server, implements `APIRepository` protocol. `MoviesAPIRepository` and `MockedMoviesAPIRepository` (For Tests) implement `MoviesAPIRepositoryProtocol` protocol (Strategy design pattern).
  - `APIError` - The error that `APIRepository` can throw.
  - `Endpoint` - Prepares the URLRequest to connect to the server (`MoviesEndpoint` implements this protocol).
  - `HTTPMethod` - The HTTP methods that allow in this application.
  - `TestAPIRepository` (For Tests) - Retrieves data from fake server using mocked session, implements `APIRepository`.
  - `MockedURLProtocol` (For Tests) - Get request and return mock response, implements `URLProtocol`.
  - `MockedAPIError` (For Tests) - The error that `TestAPIRepository` can throw.
  
   - **DBRepositories**:
  - `PersistentStore` - Allow us to fetch, update and delete items from `CoreData` database. `CoreDataStack` and `MockedPersistentStore` (For Tests) implement `PersistentStore` protocol (Strategy design pattern).
  - `CoreDataStack` - Allow access to `CoreData` storage, implements `PersistentStore`.
  - `MockedPersistenceStore` (For Tests) - Allow access to in-memory storage for testing, implements `PersistentStore`.
  - `MoviesDBRepository` - Allow us to fetch, store and delete movies. `MoviesDBRepository` and `MockedMoviesDBRepository` (For Tests) implement `MoviesDBRepositoryProtocol` protocol (Strategy design pattern).
  - `Movie` - Model that we save in `CoreData` database, this model is shown in `Views`. `Movie` model inherits from `NSManagedObject` class and implements `Identifiable` protocol.
  
- **System**
  - `Movies` - An entry point to this application.
  - `DIContainer` – Help us to inject the dependencies (Dependency injection design patterns) holds the `Interactors`, `DBRepositories`, `APIRepositories`.
  - `AppState` - Contains `ViewRouting` that control navigation between views.
  
  
## Server API
- Get a list of upcoming movies
  - HTTP Method: `GET`
  - URL: [`https://developers.themoviedb.org/3/movie/upcoming?api_key={api_key}&page={page}`](https://api.themoviedb.org/3/movie/upcoming?api_key=&page=1)
  
- Get a list of top rated movies
  - HTTP Method: `GET`
  - URL: [`https://developers.themoviedb.org/3/movie/top_rated?api_key={api_key}&page={page}`](https://api.themoviedb.org/3/movie/top_rated?api_key=&page=1)

- Get a list of now playing movies
  - HTTP Method: `GET`
  - URL: [`https://developers.themoviedb.org/3/movie/now_playing?api_key={api_key}&page={page}`](https://api.themoviedb.org/3/movie/now_playing?api_key=&page=1)
  
- Get a movie poster
  - HTTP Method: `GET`
  - URL: [`https://image.tmdb.org/t/p/original/{poster_path}`](https://image.tmdb.org/t/p/original/cIfRCA5wEvj9tApca4UDUagQEiM.jpg)
  
  
## Dependencies - Pods
  - We use [`URLImage`](https://cocoapods.org/pods/URLImage#download-an-image-in-ios-14-widget) SwiftUI view that displays an image downloaded from provided URL.
  
  
## Installation
### System requirement
- iOS 16.0 or later

### Install and Run the Movies applciation
1. Install [`CocoaPods`](https://cocoapods.org) - This is a dependency manager for Swift and Objective-C projects for Apple's platforms. 
You can install it with the following command:

```bash
$ gem install cocoapods
```

2. Navigate to the project directory and install pods from `Podfile` with the following command:

```bash
$ pod install
```

3. Open the `Movies.xcworkspace` file that was created and run it in Xcode
    
    
## Tests

### Unit Tests
Run unit tests:
1. Navigate to `MoviesTests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

### Performance Tests
Run performance tests:
1. Navigate to `MoviesPerformanceTests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

### UI Tests
Run UI tests:
1. Navigate to `MoviesUITests` target

2. Run the test from `Product` ➞ `Test` or use `⌘U` shortcuts

    
### Screen recording

1. List of movies
  <img src="https://github.com/liort2020/Movies/blob/master/Assets/MoviesScreenRecording.gif" width="220"/>

2. Filter movies
  <img src="https://github.com/liort2020/Movies/blob/master/Assets/FilterMoviesScreenRecording.gif" width="220"/>
