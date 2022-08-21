//
//  MovieStore.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 05/07/2022.
//

import Foundation

class MovieStore: MovieService {
    static let shared = MovieStore()
    private init() {}
    
    private let apiKey = "e49f0b5689c7385bb0756d511c37ea8f"
    private let baseAPIURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utilis.jsonDecoder
    
    func fetchMovies(from endpoint: MovieListEndpoint) async throws -> [Movie] {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(endpoint.rawValue)") else {
            throw MovieError.invalidEndpoint
        }
        let movieResponse: MovieResponse = try await loadURLAndDecode(url: url)
        return movieResponse.results
    }
    
    func fetchMovie(id: Int) async throws -> Movie {
        guard let url = URL(string: "\(baseAPIURL)/movie/\(id)") else {
            throw MovieError.invalidEndpoint
        }
        return try await loadURLAndDecode(url: url, params: [
            "append_to_response":"videos,credits"
        ])
    }
    
    func searchMovie(query: String) async throws -> [Movie] {
        guard let url = URL(string: "\(baseAPIURL)/search/movie") else {
            throw MovieError.invalidEndpoint
        }
        let movieResponse: MovieResponse = try await loadURLAndDecode(url: url, params: [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ])
        return movieResponse.results
    }
    
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil) async throws -> D {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw MovieError.invalidEndpoint
        }
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            throw MovieError.invalidEndpoint
        }
        let (data, response) = try await urlSession.data(from: finalURL)
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw MovieError.invalidResponse
        }
        return try jsonDecoder.decode(D.self, from: data)
    }
} 
