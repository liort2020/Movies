//
//  URLSession+Mocked.swift
//  MoviesTests
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import XCTest
@testable import Movies

extension URLSession {
    static var mockedSession: URLSession {
        let configuration: URLSessionConfiguration = .default
        configuration.protocolClasses = [MockedURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

// MARK: - MockedURLProtocol
final class MockedURLProtocol: URLProtocol {
    // Get request and return mock response
    typealias MockRequest = ((URLRequest) throws -> (HTTPURLResponse, Data?))
    static var requestHandler: MockRequest?
    
    // This method determines whether this protocol can handle the given request.
    override class func canInit(with request: URLRequest) -> Bool {
        // True if the protocol can handle the given request, False if not.
        true
    }
    
    // This method returns a canonical version of the given request.
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Send back what we received
        request
    }
    
    // Starts protocol-specific loading of a request.
    override func startLoading() {
        guard let requestHandler = Self.requestHandler, let client else { return }
        
        do {
            let (response, data) = try requestHandler(request)
            
            // Tells the client that the protocol implementation has created a response object for the request.
            client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            
            if let data {
                // Tells the client that the protocol implementation has loaded some data.
                client.urlProtocol(self, didLoad: data)
            }
            
            // Tells the client that the protocol implementation has finished loading.
            client.urlProtocolDidFinishLoading(self)
        } catch {
            // Tells the client that the load request failed due to an error.
            client.urlProtocol(self, didFailWithError: error)
        }
    }
    
    // Stops protocol-specific loading of a request.
    override func stopLoading() { }
}
