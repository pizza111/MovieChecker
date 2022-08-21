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
    @Published private(set) var phase: DataFetchPhase<Movie?> = .empty
    var movie: Movie? {
        phase.value ?? nil
    }
//    @Published var movie: Movie?
//    @Published var isLoading = false
//    @Published var error: NSError?
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) async {
        if Task.isCancelled { return }
        phase = .empty
        
        do {
            let movie = try await movieService.fetchMovie(id: id)
            phase = .success(movie)
        } catch {
            phase = .failure(error)
        }
    }
}
