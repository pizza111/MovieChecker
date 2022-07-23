//
//  MovieListView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 11/07/2022.
//

import SwiftUI
 
struct MovieListView: View {
    @ObservedObject private var nowPlayingState = MovieListState()
    @ObservedObject private var upocomingState = MovieListState()
    @ObservedObject private var topRatedState = MovieListState()
    @ObservedObject private var popularState = MovieListState()
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    if nowPlayingState.movies != nil {
                        MovieThumbnailView(title: "Now playing", movies: nowPlayingState.movies!, thumbnailType: .poster())
                    } else {
                        LoadingView(isLoading: nowPlayingState.isLoading, error: nowPlayingState.error) {
                            nowPlayingState.loadMovies(with: .nowPlaying)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
                
                Group {
                    if upocomingState.movies != nil {
                        MovieThumbnailView(title: "Upcoming", movies: upocomingState.movies!, thumbnailType: .backdrop)
                    } else {
                        LoadingView(isLoading: upocomingState.isLoading, error: upocomingState.error) {
                            upocomingState.loadMovies(with: .upcoming)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
                
                Group {
                    if topRatedState.movies != nil {
                        MovieThumbnailView(title: "Top rated", movies: topRatedState.movies!, thumbnailType: .backdrop)
                    } else {
                        LoadingView(isLoading: topRatedState.isLoading, error: topRatedState.error) {
                            topRatedState.loadMovies(with: .topRated)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
                
                Group {
                    if popularState.movies != nil {
                        MovieThumbnailView(title: "Popular", movies: popularState.movies!, thumbnailType: .backdrop)
                    } else {
                        LoadingView(isLoading: popularState.isLoading, error: popularState.error) {
                            popularState.loadMovies(with: .popular)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 16, trailing: 0))
                .listRowSeparator(.hidden)
            }
            .navigationTitle("The Movie")
            .listStyle(.plain)
            .onAppear {
                nowPlayingState.loadMovies(with: .nowPlaying)
                upocomingState.loadMovies(with: .upcoming)
                topRatedState.loadMovies(with: .topRated)
                popularState.loadMovies(with: .popular)
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
