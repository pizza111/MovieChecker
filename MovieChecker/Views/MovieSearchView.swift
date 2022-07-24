//
//  MovieSearchView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 16/07/2022.
//

import SwiftUI

struct MovieSearchView: View {
    
    @ObservedObject var movieSearchState = MovieSearchState()
    
    var body: some View {
        NavigationView {
            List {
                SearchBarView(placeholder: "Search movies", text: $movieSearchState.query)
                    .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                
                LoadingView(isLoading: movieSearchState.isLoading, error: movieSearchState.error) {
                    Task {
                        await movieSearchState.search(query: movieSearchState.query)
                    }
                }
                
                if movieSearchState.movies != nil {
                    ForEach(movieSearchState.movies!) { movie in
                        NavigationLink(destination: MovieDetailsView(movieId: movie.id)) {
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                Text(movie.yearText)
                            }
                        }
                    }
                }
            }
            .onAppear {
                movieSearchState.startObserve()
            }
            .navigationBarTitle("Search")
        }
    }
}

struct MovieSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchView()
    }
}
