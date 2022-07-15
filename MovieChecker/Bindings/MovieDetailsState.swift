//
//  MovieDetailsState.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 13/07/2022.
//

import SwiftUI

class MovieDetailState: ObservableObject {
    private let movieService: MovieService
    
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) {
        movie = nil
        isLoading = false
        movieService.fetchMovie(id: id) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
