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
    private let baseAPIURL = "https://api.themoviedb.org"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utilis.jsondDecoder
    
    func fetchMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        <#code#>
    }
    
    func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        <#code#>
    }
    
    func searchMovie(query: String, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        <#code#>
    }
    ///helper method URL into data, optional dictionary as a parameter
    private func loadURLAndDecode<D: Decodable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
        }
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
//                completion(.failure(.apiError))
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidEndpoint), completion: completion)
            }
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    private func executeCompletionHandlerInMainThread<D: Decodable>(with result: Result<D, MovieError>, completion: @escaping (Result<D, MovieError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
} 
