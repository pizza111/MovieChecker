//
//  Movie-Extensions.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 07/07/2022.
//

import Foundation

extension Movie {
    static var stubbedMovies: [Movie] {
        let response: MovieResponse = Bundle.main.loadAndDecodeJSON("movie_list")
        return response.results
    }
    static var stubbedMovie: Movie {
        stubbedMovies[0]
    }
}

extension Bundle {
    func loadAndDecodeJSON<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError()
        }
        let jsonDecoder = Utilis.jsonDecoder
        
        guard let decoded = try? jsonDecoder.decode(T.self, from: data) else {
            fatalError()
        }
        return decoded
    }
}
