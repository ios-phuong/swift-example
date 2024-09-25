//
//  MovieListPresenter.swift
//  MovieListApp
//
//  Created by phuong.doan on 25/09/2024.
//

import Foundation

protocol MovieListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func refreshData(movieObj : Movie)
    func numberOfRowsInSection() -> Int
    func showActionSheet()
    func movie(_ index: Int) -> Movie?
    func didSelectRowAt(index: Int)
}

class MovieListPresenter : MovieListPresenterProtocol {
    
    weak var viewController: MovieListViewControllerProtocol?
    let router: MovieListRouterProtocol
    let interactor: MovieListInteractorProtocol
    private var movies: [Movie] = []
    
    init(
        viewController: MovieListViewControllerProtocol,
        router: MovieListRouterProtocol,
        interactor: MovieListInteractorProtocol
    ) {
        self.viewController = viewController
        self.router = router
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        viewController?.setupTableView()
        fetchMovies()
    }
    
    func refreshData(movieObj : Movie) {
        if let indexObj = self.movies.firstIndex(where: {$0.id == movieObj.id}) {
            movies[indexObj] = movieObj
        }
        viewController?.reloadData()
    }
    
    func numberOfRowsInSection() -> Int {
        return movies.count
    }
    
    func movie(_ index: Int) -> Movie? {
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
        (viewController as? MovieListViewController)?.presentAlertWithTitleAndMessage(options: "Title", "Release Date", "Cancel", completion: { indexObj in
            if indexObj == 0 || indexObj == 1 {
                self.interactor.sortMoviesList(sortType: SortType.init(rawValue: indexObj) ?? .title, movies: self.movies)
            }
        })
    }
}

extension MovieListPresenter : MovieListInteractorOutputProtocol {
    func handleSortedMoviesList(result: [Movie]?) {
        guard let sortedMovies = result else {
            return
        }
        self.movies = sortedMovies
        viewController?.reloadData()
    }
    
    func handleMoviesListResponse(result: MovieListResult) {
        switch result {
        case .success(let movieResponse) :
            if let movies = movieResponse.movieList {
                self.movies = movies
                viewController?.reloadData()
            }
        case .failure(let error):
            print(error)
        }
    }
}
