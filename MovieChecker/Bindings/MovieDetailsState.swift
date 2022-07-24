//
//  MovieDetailsState.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 13/07/2022.
//

import SwiftUI

@MainActor
class MovieDetailState: ObservableObject {
    private let movieService: MovieService
    
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) async {
        movie = nil
        isLoading = true
        
        do {
            let movie = try await movieService.fetchMovie(id: id)
            self.movie = movie
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
}
