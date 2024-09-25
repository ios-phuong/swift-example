//
//  MovieListPresenter.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation


protocol MovieListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func refreshData(movieObj : MovieList)
    func numberOfRowsInSection() -> Int
    func showActionSheet()
    func movie(_ index: Int) -> MovieList?
    func didSelectRowAt(index: Int)
}


final class MovieListPresenter : MovieListPresenterProtocol {
    
    //MARK: - Properties
    unowned var view: MovieListViewControllerProtocol?
    let router: MovieListRouterProtocol!
    let interactor: MovieListInteractorProtocol!
    private var movies: [MovieList] = []
    
    init(
        view: MovieListViewControllerProtocol,
        router: MovieListRouterProtocol,
        interactor: MovieListInteractorProtocol
    ) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
    
    
    func viewDidLoad() {
        view?.setupTableView()
        fetchMovies()
    }
    
    func refreshData(movieObj : MovieList) {
        if let indexObj = self.movies.firstIndex(where: {$0.id == movieObj.id}) {
            movies[indexObj] = movieObj
        }
        view?.reloadData()
    }
    
    func numberOfRowsInSection() -> Int {
        return movies.count
    }
    
    func movie(_ index: Int) -> MovieList? {
        return movies[safe : index]
    }
    
    func didSelectRowAt(index: Int) {
        guard let movieObj = movie(index) else { return }
        router.navigate(.detail(movie: movieObj))
    }
    
    func fetchMovies() {
        interactor.fetchMoviesList()
    }
    
    func showActionSheet() {
        (view as? MovieListViewController)?.presentAlertWithTitleAndMessage(options: "Title", "Release Date", "Cancel", completion: { indexObj in
            if indexObj == 0 || indexObj == 1 {
                self.interactor.sortMoviesList(sortType: SortType.init(rawValue: indexObj) ?? .title, movies: self.movies)
            }
        })
    }
}

extension MovieListPresenter : MovieListInteractorOutputProtocol {
    func handleSortedMoviesList(result: [MovieList]?) {
        guard let sortedMovies = result else {
            return
        }
        self.movies = sortedMovies
        print(self.movies)
        view?.reloadData()
    }
    
    func handleMoviesListResponse(result: MovieListResult) {
        switch result {
        case .success(let movieResponse) :
            if let movies = movieResponse.movieList {
                self.movies = movies
                view?.reloadData()
            }
        case .failure(let error):
            print(error)
        }
    }
}
