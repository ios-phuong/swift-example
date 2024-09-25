//
//  MovieListInteractor.swift
//  MovieListApp
//  Created by phuong.doan on 25/09/2024.
//

import Foundation

protocol MovieListInteractorProtocol: AnyObject {
    func fetchMoviesList()
    func sortMoviesList(sortType : SortType, movies :  [MovieList])

}

protocol MovieListInteractorOutputProtocol: AnyObject {
    func handleMoviesListResponse(result: MovieListResult)
    func handleSortedMoviesList(result: [MovieList]?)
}

class ListInteractor {
    var presenter: MovieListInteractorOutputProtocol?
    var movieService: MovieServiceProtocol = MovieService()
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
}

extension ListInteractor: MovieListInteractorProtocol {
    func sortMoviesList(sortType : SortType, movies :  [MovieList]) {
        switch sortType {
        case .title :
            self.presenter?.handleSortedMoviesList(result: (movies.sorted(\.title)))
        case .releaseDate :
            print((movies.sorted(\.releaseDateObj!)))
            print(movies.map{$0.releaseDateObj})
            self.presenter?.handleSortedMoviesList(result: (movies.sorted(\.releaseDateObj!)))
        }
    }
    
    func fetchMoviesList() {
        movieService.fetchMovieList{ [weak self] result in
            guard let self = self else { return }
            self.presenter?.handleMoviesListResponse(result: result)
        }
    }
}
