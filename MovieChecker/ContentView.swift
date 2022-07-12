//
//  ContentView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 04/07/2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var nowPlayingState = MovieListState()
    @ObservedObject private var upocomingState = MovieListState()
    @ObservedObject private var topRatedState = MovieListState()
    @ObservedObject private var popularState = MovieListState()
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    if nowPlayingState.movies != nil {
                        MoviePosterView(title: "Now playing", movies: nowPlayingState.movies!)
                    } else {
                        LoadingView(isLoading: nowPlayingState.isLoading, error: nowPlayingState.error) {
                            nowPlayingState.loadMovies(with: .nowPlaying)
                        }
                    }
                }
                Group {
                    if upocomingState.movies != nil {
                        MovieBackdropView(title: "Upcoming", movies: upocomingState.movies!)
                    } else {
                        LoadingView(isLoading: upocomingState.isLoading, error: upocomingState.error) {
                            upocomingState.loadMovies(with: .upcoming)
                        }
                    }
                }
                Group {
                    if topRatedState.movies != nil {
                        MovieBackdropView(title: "Top rated", movies: topRatedState.movies!)
                    } else {
                        LoadingView(isLoading: topRatedState.isLoading, error: topRatedState.error) {
                            topRatedState.loadMovies(with: .topRated)
                        }
                    }
                }
                Group {
                    if popularState.movies != nil {
                        MovieBackdropView(title: "Popular", movies: popularState.movies!)
                    } else {
                        LoadingView(isLoading: popularState.isLoading, error: popularState.error) {
                            popularState.loadMovies(with: .popular)
                        }
                    }
                }
            }
            .navigationTitle("The Movie")
            .onAppear {
                nowPlayingState.loadMovies(with: .nowPlaying)
                upocomingState.loadMovies(with: .upcoming)
                topRatedState.loadMovies(with: .topRated)
                popularState.loadMovies(with: .popular)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
