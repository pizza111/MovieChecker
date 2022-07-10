//
//  MoviePosterView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 10/07/2022.
//

import SwiftUI

struct MoviePosterView: View {
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(movies) { movie in
                        MoviePosterCard(movie: movie)
                            .padding(.leading, movie.id == movies.first?.id ? 16 : 0)
                            .padding(.trailing, movie.id == movies.first?.id ? 16 : 0)
                    }
                }
            }
        }
    }
}

struct MoviePosterView_Previews: PreviewProvider {
    static var previews: some View {
        MoviePosterView(title: "Now playing", movies: Movie.stubbedMovies)
    }
}
