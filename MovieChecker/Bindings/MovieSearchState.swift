//
//  MovieSearchState.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 16/07/2022.
//

import SwiftUI
import Combine
import Foundation

class MovieSearchState: ObservableObject {
    
    @Published var query = ""
    @Published var movies: [Movie]?
    @Published var isLoading = false
    @Published var error: NSError?
    
    private var subscriptionToken: AnyCancellable?
    
    let movieService: MovieService
    
    var isEmptyResults: Bool {
        !self.query.isEmpty && self.movies != nil && self.movies!.isEmpty
    }
    
    init(movieService: MovieService = MovieStore.shared) {
        self.movieService = movieService
    }
    
    func startObserve() {
        guard subscriptionToken == nil else { return }
        
        self.subscriptionToken = self.$query
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
        self.movies = nil
        self.isLoading = false
        self.error = nil
        
        guard !query.isEmpty else {
            return
        }
        
        self.isLoading = true
        
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
        self.subscriptionToken?.cancel()
        self.subscriptionToken = nil
    }
}
