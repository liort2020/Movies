//
//  APIRepository.swift
//  Movies
//
//  Created by Lior Tal on 14/12/2022.
//  Copyright © 2022 Lior Tal. All rights reserved.
//

import Foundation

protocol APIRepository {
    var session: URLSession { get }
    var baseURL: String { get }
}

extension APIRepository {
    func get<T: Codable>(endpoint: Endpoint, page: Int? = nil) async throws -> T {
        guard let url = try? endpoint.request(url: baseURL, page: page) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await session.data(for: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw APIError.noResponse
        }
        
        guard response.isValidStatusCode() else {
            throw APIError.httpCode(HTTPError(code: response.statusCode))
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
