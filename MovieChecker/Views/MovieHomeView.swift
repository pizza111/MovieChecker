//
//  MovieListView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 11/07/2022.
//

import SwiftUI
 
struct MovieHomeView: View {
    @StateObject private var movieHomeState = MovieHomeState()
    
    var body: some View {
        List {
            ForEach(movieHomeState.sections) {
                MovieThumbnailView(title: $0.title, movies: $0.movies, thumbnailType: $0.thumbnailType)
            }
            .listRowInsets(.init(top: 8, leading: 0, bottom: 8, trailing: 0))
            .listRowSeparator(.hidden)
        }
        .navigationTitle("The Movie")
        .listStyle(.plain)
        .task { loadMovies(invalidateCache: false) }
        .refreshable { loadMovies(invalidateCache: true) }
        .overlay(DataFetchPhaseOverlayView(phase: movieHomeState.phase, retryAction: {
            loadMovies(invalidateCache: true)
        }))
    }
    @Sendable
    private func loadMovies(invalidateCache: Bool) {
        Task {
            await movieHomeState.loadMoviesFromAllEndpoints(invalidateCache: invalidateCache)
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieHomeView()
        }
    }
}
