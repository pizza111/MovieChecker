//
//  MoviePosterView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 10/07/2022.
//

import SwiftUI

struct MovieThumbnailView: View {
    let title: String
    let movies: [Movie]
    var thumbnailType: MovieThumbnailType = .poster()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 16) {
                    ForEach(movies) { movie in
                        NavigationLink {
                            MovieDetailsView(movieId: movie.id)
                        } label: {
                            MovieThumbnailCard(movie: movie, thumbnailType: thumbnailType)
                                .movieThumbnailViewFrame(thumbnailType: thumbnailType)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle(title)
    }
}

fileprivate extension View {
    @ViewBuilder func movieThumbnailViewFrame(thumbnailType: MovieThumbnailType) -> some View {
        switch thumbnailType {
        case .poster:
            self.frame(width: 204, height: 306)
        case .backdrop:
            self
                .aspectRatio(16/9, contentMode: .fit)
                .frame(height: 160)
        }
    }
}

struct MovieThumbnailView_Previews: PreviewProvider {
    static let stubbedMovies = Movie.stubbedMovies
    
    static var previews: some View {
        Group {
            MovieThumbnailView(title: "Now playing", movies: stubbedMovies, thumbnailType: .poster(showTitle: true))
            MovieThumbnailView(title: "Upcoming", movies: stubbedMovies, thumbnailType: .backdrop)
        }
    }
}
