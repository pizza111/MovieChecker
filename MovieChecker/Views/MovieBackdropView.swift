//
//  MovieBackdropView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 10/07/2022.
//

import SwiftUI

struct MovieBackdropView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetailsView(movieId: movie.id)
                        } label: {
                            MovieThumbnailView(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 272, height: 200)
                        .padding(.leading, movie.id == movies.first?.id ? 16 : 0)
                        .padding(.trailing, movie.id == movies.last?.id ? 16 : 0)
                    }
                }
            }
        }
    }
}

struct MovieBackdropView_Previews: PreviewProvider {
    static var previews: some View {
        MovieBackdropView(title: "Latest", movies: Movie.stubbedMovies)
    }
}
