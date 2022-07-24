//
//  MovieListState.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 10/07/2022.
//

import SwiftUI

@MainActor
class MovieListState: ObservableObject {
    @Published var movies: [Movie]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private let movieService: MovieService
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    func loadMovies(with enpoint: MovieListEndpoint) async {
        movies = nil
        isLoading = false
        do {
            let movies = try await movieService.fetchMovies(from: enpoint)
            self.isLoading = false
            self.movies = movies
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
}
