//
//  MovieDetailsView.swift
//  MovieChecker
//
//  Created by Piotr Woźniak on 13/07/2022.
//

import SwiftUI

struct MovieDetailsView: View {
    let movieId: Int
    @ObservedObject private var movieDetailsState = MovieDetailState()
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: movieDetailsState.isLoading, error: movieDetailsState.error) {
                movieDetailsState.loadMovie(id: movieId)
            }
            if movieDetailsState.movie != nil {
                MovieDetailsListView(movie: movieDetailsState.movie!)
            }
        }
        .navigationTitle(movieDetailsState.movie?.title ?? "")
        .onAppear {
            movieDetailsState.loadMovie(id: movieId)
        }
    }
}

struct MovieDetailsListView: View {
    let movie: Movie
    
    var body: some View {
        List {
            MovieDetailsImage(imageURL: movie.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            HStack {
                Text(movie.genreText)
                Text(".")
                Text(movie.yearText)
                Text(movie.durationText)
            }
            Text(movie.overview)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundColor(.yellow)
                }
                Text(movie.scoreText)
            }
            HStack(alignment: .top, spacing: 4) {
                if movie.cast != nil && movie.cast!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starring").font(.headline)
                        ForEach(movie.cast!.prefix(9)) { cast in
                            Text(cast.name )
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()
                }
                if movie.crew != nil && movie.crew!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        if movie.directors != nil && movie.directors!.count > 0 {
                            Text("Director(s)")
                                .font(.headline)
                            ForEach(movie.directors!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        if movie.producers != nil && movie.producers!.count > 0 {
                            Text("Producer(s)")
                                .font(.headline)
                                .padding(.top)
                            ForEach(movie.directors!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                            Text("Writer(s)")
                                .font(.headline)
                                .padding(.top)
                            ForEach(movie.directors!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct MovieDetailsImage: View {
    @ObservedObject private var imageLoader = ImageLoader()
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            imageLoader.loadImage(with: imageURL)
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailsView(movieId: Movie.stubbedMovie.id)            
        }
    }
}
