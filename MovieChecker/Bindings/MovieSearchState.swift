//
//  MovieSearchState.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 16/07/2022.
//

import SwiftUI
import Combine
import Foundation

@MainActor
class MovieSearchState: ObservableObject {
    @Published var query = ""
    @Published var movies: [Movie]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private var subscriptionToken: AnyCancellable?
    
    let movieService: MovieService
    
    var isEmptyResults: Bool {
        !query.isEmpty && movies != nil && movies!.isEmpty
    }
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func startObserve() {
        guard subscriptionToken == nil else { return }
        
        subscriptionToken = $query
            .map { [weak self] text in
                self?.movies = nil
                self?.error = nil
                return text
            }
//            .throttle(for: 1, scheduler: DispatchQueue.main, latest: true)
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .sink { [weak self] (query: String) in
                guard let self = self else { return }
                Task {
                    await self.search(query: query)
                }
            }
    }
    
    func search(query: String) async {
        movies = nil
        isLoading = false
        error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        isLoading = true
        
        do {
            let movies = try await movieService.searchMovie(query: query)
            guard query == self.query else { return }
            self.isLoading = false
            self.movies = movies
        } catch {
            self.isLoading = false
            self.error = error as NSError
        }
    }
    
    deinit {
        subscriptionToken?.cancel()
        subscriptionToken = nil
    }
}
